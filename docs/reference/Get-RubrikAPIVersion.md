---
external help file: Rubrik-help.xml
Module Name: Rubrik
online version: https://github.com/rubrikinc/PowerShell-Module
schema: 2.0.0
---

# Get-RubrikAPIVersion

## SYNOPSIS
Connects to Rubrik and retrieves the current API version

## SYNTAX

```
Get-RubrikAPIVersion [-Server] <String> [[-id] <String>] [[-api] <String>]
```

## DESCRIPTION
The Get-RubrikVersion cmdlet will retrieve the API version actively running on the system.
This does not require authentication.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-RubrikAPIVersion -Server 192.168.1.100
```

This will return the running API version on the Rubrik cluster reachable at the address 192.168.1.100

## PARAMETERS

### -Server
Rubrik server IP or FQDN

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
ID of the Rubrik cluster or me for self

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: Me
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
Default value: V1
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

