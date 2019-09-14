# Remove-GSAdminRole

## SYNOPSIS
Removes a specific Admin Role or a list of Admin Roles

## SYNTAX

```
Remove-GSAdminRole [-RoleId] <Int64[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes a specific Admin Role or a list of Admin Roles

## EXAMPLES

### EXAMPLE 1
```
Remove-GSAdminRole -RoleId 9191482342768644,9191482342768642
```

Removes the admin roles matching the provided Ids

## PARAMETERS

### -RoleId
The RoleId(s) you would like to remove

```yaml
Type: Int64[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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
