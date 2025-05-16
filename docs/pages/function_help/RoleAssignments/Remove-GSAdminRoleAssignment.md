# Remove-GSAdminRoleAssignment

## SYNOPSIS
Removes a specific Admin Role Assignment or the list of Admin Role Assignments

## SYNTAX

```
Remove-GSAdminRoleAssignment [-RoleAssignmentId] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes a specific Admin Role Assignment or the list of Admin Role Assignments

## EXAMPLES

### EXAMPLE 1
```
Remove-GSAdminRoleAssignment -RoleAssignmentId 9191482342768644,9191482342768642
```

Removes the role assignments matching the provided Ids

## PARAMETERS

### -RoleAssignmentId
The RoleAssignmentId(s) you would like to remove

```yaml
Type: String[]
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
