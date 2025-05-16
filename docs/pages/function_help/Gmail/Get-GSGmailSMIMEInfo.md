# Get-GSGmailSMIMEInfo

## SYNOPSIS
Gets Gmail S/MIME info

## SYNTAX

```
Get-GSGmailSMIMEInfo [-SendAsEmail] <String> [[-Id] <String[]>] [[-User] <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets Gmail S/MIME info

## EXAMPLES

### EXAMPLE 1
```
Get-GSGmailSMIMEInfo -SendAsEmail 'joe@otherdomain.com' -User joe@domain.com
```

Gets the list of S/MIME infos for Joe's SendAsEmail 'joe@otherdomain.com'

## PARAMETERS

### -Id
The immutable ID for the SmimeInfo.

If left blank, returns the list of S/MIME infos for the SendAsEmail and User

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SendAsEmail
The email address that appears in the "From:" header for mail sent using this alias.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The user's email address

Defaults to the AdminEmail user

```yaml
Type: String
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail

Required: False
Position: 3
Default value: $Script:PSGSuite.AdminEmail
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Gmail.v1.Data.SmimeInfo
## NOTES

## RELATED LINKS
