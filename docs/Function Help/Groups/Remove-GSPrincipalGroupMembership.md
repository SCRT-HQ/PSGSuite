# Remove-GSPrincipalGroupMembership

## SYNOPSIS
Removes the target member from a group or list of groups

## SYNTAX

```
Remove-GSPrincipalGroupMembership [-Identity] <String> [-MemberOf] <String[]> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Removes the target member from a group or list of groups

## EXAMPLES

### EXAMPLE 1
```
Remove-GSPrincipalGroupMembership -Identity 'joe.smith' -MemberOf admins,test_pool
```

Removes Joe Smith from the groups admins@domain.com and test_pool@domain.com

## PARAMETERS

### -Identity
The email or unique Id of the member you would like to remove from the group(s)

```yaml
Type: String
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail, User, UserEmail

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -MemberOf
The group(s) to remove the member from

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: GroupEmail, Group, Email

Required: True
Position: 2
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
