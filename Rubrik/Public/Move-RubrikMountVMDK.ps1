﻿#Requires -Version 3
function Move-RubrikMountVMDK
{
  <#  
      .SYNOPSIS
      Moves the VMDKs from a Live Mount to another VM

      .DESCRIPTION
      The Move-RubrikMountVMDK cmdlet is used to attach VMDKs from a Live Mount to another VM, typically for restore or testing purposes.

      .NOTES
      Written by Chris Wahl for community usage
      Twitter: @ChrisWahl
      GitHub: chriswahl

      .LINK
      https://github.com/rubrikinc/PowerShell-Module

      .EXAMPLE
      Move-RubrikMountVMDK -SourceVM 'SourceVM' -TargetVM 'TargetVM'
      This will create a Live Mount using the latest snapshot of the VM named "SourceVM"
      The Live Mount's VMDKs would then be presented to the VM named "TargetVM"
      
      .EXAMPLE
      Move-RubrikMountVMDK -SourceVM 'SourceVM' -TargetVM 'TargetVM' -OnlineDisks
      This will create a Live Mount using the latest snapshot of the VM named "SourceVM"
      The Live Mount's VMDKs would then be presented to the VM named "TargetVM" and brought online.

      .EXAMPLE
      Move-RubrikMountVMDK -SourceVM 'SourceVM' -TargetVM 'TargetVM' -Date '01/30/2016 08:00'
      This will create a Live Mount using the January 30th 08:00AM snapshot of the VM named "SourceVM"
      The Live Mount's VMDKs would then be presented to the VM named "TargetVM"
      Note: The Date parameter will start at the time specified (in this case, 08:00am) and work backwards in time until it finds a snapshot.
      Precise timing is not required.
    
      .EXAMPLE
      Move-RubrikMountVMDK -SourceVM 'SourceVM' -TargetVM 'TargetVM' -ExcludeDisk @(0,1)
      This will create a Live Mount using the latest snapshot of the VM named "SourceVM"
      Disk 0 and 1 (the first and second disks) would be excluded from presentation to the VM named "TargetVM"
      Note: that for the "ExcludeDisk" array, the format is @(#,#,#,...) where each # represents a disk starting with 0.
      Example: To exclude the first and third disks, the value would be @(0,2).
      Example: To exclude just the first disk, use @(0).

      .EXAMPLE
      Move-RubrikMountVMDK -Cleanup 'C:\Users\Person1\Documents\SourceVM_to_TargetVM-1234567890.txt'
      This will remove the disk(s) and live mount, effectively reversing the initial request
      This file is created each time the command is run and stored in the $HOME path as a text file
      The file contains the TargetVM name, MountID value, and a list of all presented disks
  #>

  [CmdletBinding(SupportsShouldProcess = $true,ConfirmImpact = 'High')]
  Param(
    # Source virtual machine to use as a Live Mount based on a previous backup
    [Parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ParameterSetName = 'Create')]
    [Alias('Name','VM')]
    [ValidateNotNullorEmpty()]
    [String]$SourceVM,
    # Target virtual machine to attach the Live Mount disk(s)
    [Parameter(Mandatory = $true,Position = 1,ParameterSetName = 'Create')]
    [ValidateNotNullorEmpty()]
    [String]$TargetVM,
    # Backup date to use for the Live Mount
    # Will use the current date and time if no value is specified
    [Parameter(Position = 2,ParameterSetName = 'Create')]
    [String]$Date,
    # An array of disks to exclude from presenting to the target virtual machine
    # By default, all disks will be presented
    [Parameter(Position = 3,ParameterSetName = 'Create')]
    [Array]$ExcludeDisk,
    # Boolean value to online disks
    # All disks will be onlined.
    [Parameter(Position = 4,ParameterSetName = 'Create')]
    [Switch]$OnlineDisks,
    # The path to a cleanup file to remove the live mount and presented disks
    # The cleanup file is created each time the command is run and stored in the $HOME path as a text file with a random number value
    # The file contains the TargetVM name, MountID value, and a list of all presented disks
    [Parameter(ParameterSetName = 'Destroy')]    
    [String]$Cleanup,
    # Rubrik server IP or FQDN
    [String]$Server = $global:RubrikConnection.server,
    # API version
    [String]$api = $global:RubrikConnection.api
  )

  Begin {

    Test-RubrikConnection
    Test-VMwareConnection
  
  }

  Process {

    if (!$Cleanup)
    {
      if (!$Date) 
      {
        Write-Verbose -Message 'No date entered. Taking current time.'
        $Date = Get-Date
      }

      $HostID = (Get-RubrikVM -VM $TargetVM).hostId

      Write-Verbose -Message "Creating a powered off Live Mount of $SourceVM"
      $mount = Get-RubrikVM $SourceVM | Get-RubrikSnapshot -Date $Date | New-RubrikMount -HostID $HostID
    
      Write-Verbose -Message "Waiting for request $($mount.id) to complete"
      while ((Get-RubrikRequest -ID $mount.id -Type "vmware/vm").status -ne 'SUCCEEDED')
      {
        Start-Sleep -Seconds 1
      }
    
      Write-Verbose -Message 'Live Mount is now available'
      Write-Verbose -Message 'Gathering Live Mount ID value'
      foreach ($link in ((Get-RubrikRequest -ID $mount.id -Type "vmware/vm").links))
      {
        # There are two links - the request (self) and result
        # This will filter the values to just the result
        if ($link.rel -eq 'result')
        {
          # We just want the very last part of the link, which contains the ID value
          $MountID = $link.href.Split('/')[-1]
        }
      }

      Write-Verbose -Message 'Gathering details on the Live Mount'
      $MountVM = Get-RubrikVM -id (Get-RubrikMount -id $MountID).mountedVmId

      Write-Verbose -Message 'Gathering details on the Target VM'
      $TargetHost = Get-VMHost -VM $TargetVM

      Write-Verbose -Message 'Migrating the Mount VMDKs to VM'
      if ($PSCmdlet.ShouldProcess($TargetVM,'Migrating Live Mount VMDK(s)'))
      {
        [array]$MountVMdisk = Get-HardDisk $MountVM.name
        $MountedVMdiskFileNames = @()
        [int]$j = 0
        foreach ($_ in $MountVMdisk)
        {
          if ($ExcludeDisk -contains $j)
          {
            Write-Verbose -Message "Skipping Disk $j" -Verbose
          }
          else 
          {
            try
            {
              $null = Remove-HardDisk -HardDisk $_ -DeletePermanently:$false -Confirm:$false
              $null = New-HardDisk -VM $TargetVM -DiskPath $_.Filename
              $MountedVMdiskFileNames += $_.Filename
              Write-Verbose -Message "Migrated $($_.Filename) to $TargetVM"
              if ($OnlineDisks)
			        {
                Get-Disk | Where-Object IsOffline -Eq $True | Set-Disk -IsOffline $False
                Write-Verbose -Message 'Onlined attached disks'
              }
            }
            catch
            {
              throw $_
            }
          }
          $j++
        }
      }

      $Diskfile = "$Home\Documents\"+$SourceVM+'_to_'+$TargetVM+'-'+(Get-Date).Ticks+'.txt'
      $TargetVM | Out-File -FilePath $Diskfile -Encoding utf8 -Force
      $MountID | Out-File -FilePath $Diskfile -Encoding utf8 -Append -Force      
      $MountedVMdiskFileNames | Out-File -FilePath $Diskfile -Encoding utf8 -Append -Force

      # Return information needed to cleanup the mounted disks and Live Mount      
      $response = @{}
      $response.Add('Status','Success')
      $response.add('CleanupFile',$Diskfile)
      $response.Add('Example',"Move-RubrikMountVMDK -Cleanup `'$Diskfile`'")
      return $response
    }

    elseif ($Cleanup) 
    {
      if ((Test-Path $Cleanup) -ne $true) 
      {
        throw 'File does not exist'
      }
      $TargetVM = (Get-Content -Path $Cleanup -Encoding UTF8)[0]
      $MountID = (Get-Content -Path $Cleanup -Encoding UTF8)[1]      
      $MountedVMdiskFileNames = (Get-Content -Path $Cleanup -Encoding UTF8) | Select-Object -Skip 2
      Write-Verbose -Message 'Removing disks from the VM'
      [array]$SourceVMdisk = Get-HardDisk $TargetVM
      foreach ($_ in $SourceVMdisk)
      {
        if ($MountedVMdiskFileNames -contains $_.Filename)
        {
          Write-Verbose -Message "Removing $_ from $TargetVM"
          Remove-HardDisk -HardDisk $_ -DeletePermanently:$false -Confirm:$false
        }
      }
        
      Write-Verbose -Message "Deleting the Live Mount named $($MountVM.name)"
      Remove-RubrikMount -id $MountID -Confirm:$false
    }

  } # End of process
} # End of function
