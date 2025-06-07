# Get-GSGmailForwardingAddress

## SYNOPSIS
Gets Gmail forwarding address information for the user

## SYNTAX

```
Get-GSGmailForwardingAddress [-ForwardingAddress <String[]>] [[-User] <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets Gmail forwarding address information for the user

## EXAMPLES

### EXAMPLE 1
```
Get-GSGmailForwardingAddress
```

Gets the list of forwarding addresses for the AdminEmail user

## PARAMETERS

### -ForwardingAddress
The forwarding address you would like to get info for.
If excluded, gets the list of forwarding addresses and their info for the user

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Id

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -User
The user to get the forwarding addresses for

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
