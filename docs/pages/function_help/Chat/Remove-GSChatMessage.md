# Remove-GSChatMessage

## SYNOPSIS
Removes a Chat message

## SYNTAX

```
Remove-GSChatMessage [-Name] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes a Chat message

## EXAMPLES

### EXAMPLE 1
```
Remove-GSChatMessage -Name 'spaces/AAAAMpdlehY/messages/UMxbHmzDlr4.UMxbHmzDlr4'
```

Removes the Chat message specified after confirmation

## PARAMETERS

### -Name
Resource name of the message to be removed, in the form "spaces/messages".

Example: spaces/AAAAMpdlehY/messages/UMxbHmzDlr4.UMxbHmzDlr4

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Id

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
