# Remove-GSGroupAlias

## SYNOPSIS
Removes an alias from a G Suite group

## SYNTAX

```
Remove-GSGroupAlias [-Group] <String> [-Alias] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes an alias from a G Suite group

## EXAMPLES

### EXAMPLE 1
```
Remove-GSGroupAlias -Group humanresources@domain.com -Alias 'hr@domain.com','hrhelp@domain.com'
```

Removes 2 aliases for group Human Resources: 'hr@domain.com' and 'hrhelp@domain.com'

## PARAMETERS

### -Alias
The alias or list of aliases to remove from the group

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Group
The group to remove the alias from

```yaml
Type: String
Parameter Sets: (All)
Aliases: Email

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
