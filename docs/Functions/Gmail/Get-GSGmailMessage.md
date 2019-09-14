# Get-GSGmailMessage

## SYNOPSIS
Gets Gmail message details

## SYNTAX

### Format (Default)
```
Get-GSGmailMessage [-User <String>] -Id <String[]> [-Format <String>] [<CommonParameters>]
```

### ParseMessage
```
Get-GSGmailMessage [-User <String>] -Id <String[]> [-ParseMessage] [-SaveAttachmentsTo <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Gets Gmail message details

## EXAMPLES

### EXAMPLE 1
```
Get-GSGmailMessage -Id 1615f9a6ee36cb5b -ParseMessage
```

Gets the full message details for the provided Id and parses out the raw MIME message content

## PARAMETERS

### -Format
The format of the message metadata to retrieve

Available values are:
* "Full"
* "Metadata"
* "Minimal"
* "Raw"

Defaults to "Full", but forces -Format as "Raw" if -ParseMessage or -SaveAttachmentsTo are used

```yaml
Type: String
Parameter Sets: Format
Aliases:

Required: False
Position: Named
Default value: Full
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
The Id of the message to retrieve info for

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: MessageId

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ParseMessage
If $true, returns the parsed raw message

```yaml
Type: SwitchParameter
Parameter Sets: ParseMessage
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SaveAttachmentsTo
If the message has attachments, the path to save the attachments to.
If excluded, attachments are not saved locally

```yaml
Type: String
Parameter Sets: ParseMessage
Aliases: AttachmentOutputPath, OutFilePath

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The primary email of the user who owns the message

Defaults to the AdminEmail user

```yaml
Type: String
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail

Required: False
Position: Named
Default value: $Script:PSGSuite.AdminEmail
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Gmail.v1.Data.Message
## NOTES

## RELATED LINKS
