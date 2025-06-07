# Get-GSGmailSendAsAlias

## SYNOPSIS
Gets SendAs alias settings for a user.

## SYNTAX

```
Get-GSGmailSendAsAlias [[-SendAsEmail] <String[]>] [-User <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets SendAs alias settings for a user.

## EXAMPLES

### EXAMPLE 1
```
Get-GSGmailSendAsSettings -User joe@domain.com
```

Gets the list of SendAs Settings for Joe

## PARAMETERS

### -SendAsEmail
The SendAs alias to be retrieved.

If excluded, gets the list of SendAs aliases.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: SendAs

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -User
The email of the user you are getting the information for

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

### Google.Apis.Gmail.v1.Data.SendAs
## NOTES

## RELATED LINKS
