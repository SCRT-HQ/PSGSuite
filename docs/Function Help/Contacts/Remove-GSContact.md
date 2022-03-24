# Remove-GSContact

## SYNOPSIS
Removes the specified contact

## SYNTAX

```
Remove-GSContact [[-ContactId] <String[]>] [-User <String>] [-Etag <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Removes the specified contact

## EXAMPLES

### EXAMPLE 1
```
Recommended to use Get-GSContactList to find and pipe desired contacts to Remove-GSContact:
```

Get-GSContactList -User user@domain.com | Where-Object {"@baddomain.com" -match $_.EmailAddresses} | Remove-GSContact

Removes all contacts for user@domain.com that have an email address on the baddomain.com domain.

## PARAMETERS

### -ContactId
The ContactID to be removed.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Id

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Etag
The Etag string from a Get-GSContactList object.
Used to ensure that no changes have been made to the contact since it was viewed in order to prevent data loss.

Defaults to special Etag value *, which can be used to bypass this verification and process the update regardless of updates from other clients.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: *
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -User
The primary email or UserID of the user.
You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

Defaults to the AdminEmail in the config.

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

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
