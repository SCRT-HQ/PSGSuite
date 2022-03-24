# Remove-GSUserSchema

## SYNOPSIS
Removes a custom user schema

## SYNTAX

```
Remove-GSUserSchema [[-SchemaId] <String[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes a custom user schema

## EXAMPLES

### EXAMPLE 1
```
Remove-GSUserSchema 2SV
```

Removes the custom user schema named '2SV' after confirmation

## PARAMETERS

### -SchemaId
The SchemaId or SchemaName to remove.
If excluded, all Custom User Schemas for the customer will be removed

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Schema, SchemaKey, SchemaName

Required: False
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
