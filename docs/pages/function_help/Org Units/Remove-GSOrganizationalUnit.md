# Remove-GSOrganizationalUnit

## SYNOPSIS
Removes an OrgUnit

## SYNTAX

```
Remove-GSOrganizationalUnit [-OrgUnitPath] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes an Organization Unit

## EXAMPLES

### EXAMPLE 1
```
Remove-GSOrganizationalUnit -OrgUnitPath "/Testing"
```

Removes the OrgUnit "/Testing" on confirmation

## PARAMETERS

### -OrgUnitPath
The path of the OrgUnit you would like to Remove-GSOrganizationalUnit

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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
