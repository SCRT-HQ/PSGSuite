# Remove-GSResource

## SYNOPSIS
Removes a resource

## SYNTAX

### Calendars (Default)
```
Remove-GSResource [-ResourceId] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Buildings
```
Remove-GSResource [-BuildingId] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Features
```
Remove-GSResource [-FeatureKey] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes a resource

## EXAMPLES

### EXAMPLE 1
```
Remove-GSResource -ResourceId Train01
```

Removes the Resource Calendar 'Train01' after confirmation

## PARAMETERS

### -BuildingId
The Building Id of the Resource *Building* you would like to remove

```yaml
Type: String[]
Parameter Sets: Buildings
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -FeatureKey
The Feature Key of the Resource *Feature* you would like to remove

```yaml
Type: String[]
Parameter Sets: Features
Aliases: Name

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ResourceId
The Resource Id of the Resource *Calendar* you would like to remove

```yaml
Type: String[]
Parameter Sets: Calendars
Aliases: CalendarResourceId

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
