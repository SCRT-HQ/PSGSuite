# Add-GSDrivePermission

## SYNOPSIS
Adds a new permission to a Drive file

## SYNTAX

### Email (Default)
```
Add-GSDrivePermission [-FileId] <String> -Role <String> -Type <String> [[-User] <String>]
 [-EmailAddress <String>] [-ExpirationTime <DateTime>] [-EmailMessage <String>] [-SendNotificationEmail]
 [-AllowFileDiscovery] [-TransferOwnership] [-UseDomainAdminAccess] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Domain
```
Add-GSDrivePermission [-FileId] <String> -Role <String> -Type <String> [[-User] <String>] [-Domain <String>]
 [-ExpirationTime <DateTime>] [-EmailMessage <String>] [-SendNotificationEmail] [-AllowFileDiscovery]
 [-TransferOwnership] [-UseDomainAdminAccess] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Adds a new permission to a Drive file

## EXAMPLES

### EXAMPLE 1
```
Add-GSDrivePermission -FileId "1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976" -Role Owner -Type User -EmailAddress joe -SendNotificationEmail -Confirm:$false
```

Adds user joe@domain.com as the new owner of the file Id and sets the AdminEmail user as a Writer on the file

## PARAMETERS

### -AllowFileDiscovery
Whether the permission allows the file to be discovered through search.

This is only applicable for permissions of type domain or anyone

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

### -Domain
The domain to which this permission refers

```yaml
Type: String
Parameter Sets: Domain
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailAddress
The email address of the user or group to which this permission refers

```yaml
Type: String
Parameter Sets: Email
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailMessage
A plain text custom message to include in the notification email

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

### -ExpirationTime
The time at which this permission will expire.

Expiration times have the following restrictions:
* They can only be set on user and group permissions
* The time must be in the future
* The time cannot be more than a year in the future

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileId
The unique Id of the Drive file you would like to add the permission to

```yaml
Type: String
Parameter Sets: (All)
Aliases: Id

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Role
The role/permission set you would like to give the email $EmailAddress

Available values are:
* "Owner"
* "Writer"
* "Commenter"
* "Reader"
* "Organizer"
* "FileOrganizer"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SendNotificationEmail
Whether to send a notification email when sharing to users or groups.

This defaults to **FALSE** for users and groups in PSGSuite, and is not allowed for other requests.

**It must not be disabled for ownership transfers**

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

### -TransferOwnership
Confirms transfer of ownership if the Role is set to 'Owner'.
You can also force the same behavior by passing -Confirm:$false instead

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: ConfirmTransferOfOwnership, TransferOfOwnership

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
The type of the grantee

Available values are:
* "User": a user email
* "Group": a group email
* "Domain": the entire domain
* "Anyone": public access

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseDomainAdminAccess
Whether the request should be treated as if it was issued by a domain administrator; if set to true, then the requester will be granted access if they are an administrator of the domain to which the item belongs

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

### -User
The owner of the Drive file

Defaults to the AdminEmail user

```yaml
Type: String
Parameter Sets: (All)
Aliases: Owner, PrimaryEmail, UserKey, Mail

Required: False
Position: 2
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

### Google.Apis.Drive.v3.Data.Permission
## NOTES

## RELATED LINKS
