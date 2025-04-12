# Get-GSChatMessage

## SYNOPSIS
Gets a Chat message

## SYNTAX

```
Get-GSChatMessage [-Name] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Gets a Chat message

## EXAMPLES

### EXAMPLE 1
```
Get-GSChatMessage -Name 'spaces/AAAAMpdlehY/messages/UMxbHmzDlr4.UMxbHmzDlr4'
```

Gets the Chat message specified

## PARAMETERS

### -Name
Resource name of the message to be retrieved, in the form "spaces/messages".

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.HangoutsChat.v1.Data.Message
## NOTES

## RELATED LINKS
