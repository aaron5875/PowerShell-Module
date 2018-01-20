---
external help file: Rubrik-help.xml
Module Name: Rubrik
online version: https://github.com/rubrikinc/PowerShell-Module
schema: 2.0.0
---

# Remove-RubrikFileset

## SYNOPSIS
Delete a fileset by specifying the fileset ID

## SYNTAX

```
Remove-RubrikFileset [-id] <String> [[-Server] <String>] [[-api] <String>] [-WhatIf] [-Confirm]
```

## DESCRIPTION
The Remove-RubrikFileset cmdlet is used to remove a fileset registered with the Rubrik cluster.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-RubrikFileset -Name 'C_Drive' | Remove-RubrikHost
```

This will remove any fileset that matches the name "C_Drive"

### -------------------------- EXAMPLE 2 --------------------------
```
Remove-RubrikFileset -id 'Fileset:::111111-2222-3333-4444-555555555555'
```

This will specifically remove the fileset id matching "Fileset:::111111-2222-3333-4444-555555555555"

## PARAMETERS

### -id
The Rubrik ID value of the fileset

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Server
Rubrik server IP or FQDN

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: $global:RubrikConnection.server
Accept pipeline input: False
Accept wildcard characters: False
```

### -api
API version

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: $global:RubrikConnection.api
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES
Written by Chris Wahl for community usage
Twitter: @ChrisWahl
GitHub: chriswahl

## RELATED LINKS

[https://github.com/rubrikinc/PowerShell-Module](https://github.com/rubrikinc/PowerShell-Module)

