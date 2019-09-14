# Get-GSChatSpace

## SYNOPSIS
Gets a Chat space

## SYNTAX

```
Get-GSChatSpace [[-Space] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Gets a Chat space

## EXAMPLES

### EXAMPLE 1
```
Get-GSChatSpace
```

Gets the list of Chat spaces the bot is a member of

## PARAMETERS

### -Space
The resource name of the space for which membership list is to be fetched, in the form "spaces".

If left blank, returns the list of spaces the bot is a member of

Example: spaces/AAAAMpdlehY

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Name

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.HangoutsChat.v1.Data.Space
## NOTES

## RELATED LINKS
