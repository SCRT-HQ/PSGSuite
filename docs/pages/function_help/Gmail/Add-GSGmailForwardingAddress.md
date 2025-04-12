# Add-GSGmailForwardingAddress

## SYNOPSIS
Creates a forwarding address.

## SYNTAX

```
Add-GSGmailForwardingAddress [-ForwardingAddress] <String[]> [[-User] <String>] [<CommonParameters>]
```

## DESCRIPTION
Creates a forwarding address.
If ownership verification is required, a message will be sent to the recipient and the resource's verification status will be set to pending; otherwise, the resource will be created with verification status set to accepted.

## EXAMPLES

### EXAMPLE 1
```
Add-GSGmailForwardingAddress "joe@domain.com"
```

Adds joe@domain.com as a forwarding address for the AdminEmail user

## PARAMETERS

### -ForwardingAddress
An email address to which messages can be forwarded.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Id

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -User
The user to create the forwarding addresses for

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

### Google.Apis.Gmail.v1.Data.ForwardingAddress
## NOTES

## RELATED LINKS
