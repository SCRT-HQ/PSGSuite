# Remove-GSGmailDelegate

## SYNOPSIS
Removes the specified delegate (which can be of any verification status), and revokes any verification that may have been required for using it.

## SYNTAX

```
Remove-GSGmailDelegate [-User] <String> [-Delegate] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes the specified delegate (which can be of any verification status), and revokes any verification that may have been required for using it.

Note that a delegate user must be referred to by their primary email address, and not an email alias.

## EXAMPLES

### EXAMPLE 1
```
Remove-GSGmailDelegate -User tony@domain.com -Delegate peter@domain.com
```

Removes Peter's access to Tony's inbox.

## PARAMETERS

### -Delegate
Delegate's email address to remove

```yaml
Type: String
Parameter Sets: (All)
Aliases: To

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
User's email address to remove delegate access to

```yaml
Type: String
Parameter Sets: (All)
Aliases: From, Delegator

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
