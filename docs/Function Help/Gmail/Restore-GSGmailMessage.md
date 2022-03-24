# Restore-GSGmailMessage

## SYNOPSIS
Restores a trashed message to the inbox

## SYNTAX

```
Restore-GSGmailMessage [[-User] <String>] [-Id] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Restores a trashed message to the inbox

## EXAMPLES

### EXAMPLE 1
```
Restore-GSGmailMessage -User joe -Id 161622d7b76b7e1e,1616227c34d435f2
```

Restores the 2 message Id's from Joe's TRASH back to their inbox

## PARAMETERS

### -Id
The Id of the message to restore

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: MessageID

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -User
The primary email of the user to restore the message for

Defaults to the AdminEmail user

```yaml
Type: String
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail

Required: False
Position: 1
Default value: $Script:PSGSuite.AdminEmail
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
