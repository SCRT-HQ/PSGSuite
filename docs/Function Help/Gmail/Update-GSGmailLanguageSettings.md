# Update-GSGmailLanguageSettings

## SYNOPSIS
Updates Gmail display language settings

## SYNTAX

```
Update-GSGmailLanguageSettings [-User] <String[]> [-Language] <String> [<CommonParameters>]
```

## DESCRIPTION
Updates Gmail display language settings

## EXAMPLES

### EXAMPLE 1
```
Update-GSGmailLanguageSettings -User me -Language fr
```

Updates the Gmail display language to French for the AdminEmail user.

## PARAMETERS

### -Language
The language to display Gmail in, formatted as an RFC 3066 Language Tag (for example en-GB, fr or ja for British English, French, or Japanese respectively).

The set of languages supported by Gmail evolves over time, so please refer to the "Language" dropdown in the Gmail settings for all available options, as described in the language settings help article.
A table of sample values is also provided in the Managing Language Settings guide

Not all Gmail clients can display the same set of languages.
In the case that a user's display language is not available for use on a particular client, said client automatically chooses to display in the closest supported variant (or a reasonable default).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The user to update the Gmail display language settings for

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Gmail.v1.Data.LanguageSettings
## NOTES

## RELATED LINKS
