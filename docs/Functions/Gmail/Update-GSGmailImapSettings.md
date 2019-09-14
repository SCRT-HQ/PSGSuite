# Update-GSGmailImapSettings

## SYNOPSIS
Updates IMAP settings

## SYNTAX

```
Update-GSGmailImapSettings [-User] <String> [-AutoExpunge] [-Enabled] [-ExpungeBehavior <String>]
 [-MaxFolderSize <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Updates IMAP settings

## EXAMPLES

### EXAMPLE 1
```
Update-GSGmailImapSettings -Enabled:$false -User me
```

Disables IMAP for the AdminEmail user

## PARAMETERS

### -AutoExpunge
If this value is true, Gmail will immediately expunge a message when it is marked as deleted in IMAP.
Otherwise, Gmail will wait for an update from the client before expunging messages marked as deleted.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Enabled
Whether IMAP is enabled for the account.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExpungeBehavior
The action that will be executed on a message when it is marked as deleted and expunged from the last visible IMAP folder.

Acceptable values are:
* "archive": Archive messages marked as deleted.
* "deleteForever": Immediately and permanently delete messages marked as deleted.
The expunged messages cannot be recovered.
* "expungeBehaviorUnspecified": Unspecified behavior.
* "trash": Move messages marked as deleted to the trash.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxFolderSize
An optional limit on the number of messages that an IMAP folder may contain.
Legal values are 0, 1000, 2000, 5000 or 10000.
A value of zero is interpreted to mean that there is no limit.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The user to update the IMAP settings for

```yaml
Type: String
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

### Google.Apis.Gmail.v1.Data.ImapSettings
## NOTES

## RELATED LINKS
