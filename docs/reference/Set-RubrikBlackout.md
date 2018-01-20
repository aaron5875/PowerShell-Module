---
external help file: Rubrik-help.xml
Module Name: Rubrik
online version: https://github.com/rubrikinc/PowerShell-Module
schema: 2.0.0
---

# Set-RubrikBlackout

## SYNOPSIS
Connects to Rubrik and sets blackout (stops/starts all snaps)

## SYNTAX

```
Set-RubrikBlackout [-Set] [[-Server] <String>] [[-api] <String>] [-WhatIf] [-Confirm]
```

## DESCRIPTION
The Set-RubrikBlackout cmdlet will accept a flag of true/false to set cluster blackout

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Set-RubrikBlackout -Set [true/false]
```

## PARAMETERS

### -Set
Rubrik blackout value

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: isGlobalBlackoutActive

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Server
Rubrik server IP or FQDN

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
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
Position: 2
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
Written by Pete Milanese for community usage
Twitter: @pmilano1
GitHub: pmilano1

## RELATED LINKS

[https://github.com/rubrikinc/PowerShell-Module](https://github.com/rubrikinc/PowerShell-Module)

