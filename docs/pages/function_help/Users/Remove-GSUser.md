# Remove-GSUser

## SYNOPSIS
Removes a user

## SYNTAX

```
Remove-GSUser [[-User] <String[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes a user

## EXAMPLES

### EXAMPLE 1
```
Remove-GSUser joe -Confirm:$false
```

Removes the user 'joe@domain.com', skipping confirmation

## PARAMETERS

### -User
The primary email or unique Id of the user to Remove-GSUser

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail

Required: False
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
