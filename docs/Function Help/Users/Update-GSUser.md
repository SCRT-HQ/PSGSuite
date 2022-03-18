# Update-GSUser

## SYNOPSIS
Updates a user

## SYNTAX

### NamePart (Default)
```
Update-GSUser [-User] <String[]> [-PrimaryEmail <String>] [-GivenName <String>] [-FamilyName <String>]
 [-Password <SecureString>] [-ChangePasswordAtNextLogin] [-OrgUnitPath <String>] [-Suspended]
 [-Addresses <UserAddress[]>] [-Emails <UserEmail[]>] [-ExternalIds <UserExternalId[]>] [-Ims <UserIm[]>]
 [-Locations <UserLocation[]>] [-Organizations <UserOrganization[]>] [-Relations <UserRelation[]>]
 [-RecoveryEmail <String>] [-RecoveryPhone <String>] [-Phones <UserPhone[]>] [-IncludeInGlobalAddressList]
 [-IpWhitelisted] [-IsAdmin] [-CustomSchemas <Hashtable>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### FullName
```
Update-GSUser [-User] <String[]> [-PrimaryEmail <String>] [-FullName <String>] [-Password <SecureString>]
 [-ChangePasswordAtNextLogin] [-OrgUnitPath <String>] [-Suspended] [-Addresses <UserAddress[]>]
 [-Emails <UserEmail[]>] [-ExternalIds <UserExternalId[]>] [-Ims <UserIm[]>] [-Locations <UserLocation[]>]
 [-Organizations <UserOrganization[]>] [-Relations <UserRelation[]>] [-RecoveryEmail <String>]
 [-RecoveryPhone <String>] [-Phones <UserPhone[]>] [-IncludeInGlobalAddressList] [-IpWhitelisted] [-IsAdmin]
 [-CustomSchemas <Hashtable>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates a user

## EXAMPLES

### EXAMPLE 1
```
Update-GSUser -User john.smith@domain.com -PrimaryEmail johnathan.smith@domain.com -GivenName Johnathan -Suspended:$false
```

Updates user john.smith@domain.com with a new primary email of "johnathan.smith@domain.com", sets their Given Name to "Johnathan" and unsuspends them.
Their previous primary email "john.smith@domain.com" will become an alias on their account automatically

## PARAMETERS

### -Addresses
The address objects of the user

This parameter expects a 'Google.Apis.Admin.Directory.directory_v1.Data.UserAddress\[\]' object type.
You can create objects of this type easily by using the function 'Add-GSUserAddress'

```yaml
Type: UserAddress[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ChangePasswordAtNextLogin
If set, user will need to change their password on their next login

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

### -CustomSchemas
Custom user attribute values to add to the user's account.
This parameter only accepts a hashtable where the keys are Schema Names and the value for each key is another hashtable, i.e.:

    Update-GSUser -User john.smith@domain.com -CustomSchemas @{
        schemaName1 = @{
            fieldName1 = $fieldValue1
            fieldName2 = $fieldValue2
        }
        schemaName2 = @{
            fieldName3 = $fieldValue3
        }
    }

If you need to CLEAR a custom schema value, simply pass $null as the value(s) for the fieldName in the hashtable, i.e.:

    Update-GSUser -User john.smith@domain.com -CustomSchemas @{
        schemaName1 = @{
            fieldName1 = $null
            fieldName2 = $null
        }
        schemaName2 = @{
            fieldName3 = $null
        }
    }

The Custom Schema and it's fields **MUST** exist prior to updating these values for a user otherwise it will return an error.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Emails
The email objects of the user

This parameter expects a 'Google.Apis.Admin.Directory.directory_v1.Data.UserEmail\[\]' object type.
You can create objects of this type easily by using the function 'Add-GSUserEmail'

```yaml
Type: UserEmail[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExternalIds
The externalId objects of the user

This parameter expects a 'Google.Apis.Admin.Directory.directory_v1.Data.UserExternalId\[\]' object type.
You can create objects of this type easily by using the function 'Add-GSUserExternalId'

To CLEAR all values for a user, pass \`$null\` as the value for this parameter.

```yaml
Type: UserExternalId[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FamilyName
The new family (last) name for the user

```yaml
Type: String
Parameter Sets: NamePart
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FullName
The new full name for the user

```yaml
Type: String
Parameter Sets: FullName
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GivenName
The new given (first) name for the user

```yaml
Type: String
Parameter Sets: NamePart
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Ims
The IM objects of the user

This parameter expects a 'Google.Apis.Admin.Directory.directory_v1.Data.UserIm\[\]' object type.
You can create objects of this type easily by using the function 'Add-GSUserIm'

To CLEAR all values for a user, pass \`$null\` as the value for this parameter.

```yaml
Type: UserIm[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeInGlobalAddressList
Indicates if the user's profile is visible in the G Suite global address list when the contact sharing feature is enabled for the domain.
For more information about excluding user profiles, see the administration help center: http://support.google.com/a/bin/answer.py?answer=1285988

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

### -IpWhitelisted
If true, the user's IP address is white listed: http://support.google.com/a/bin/answer.py?answer=60752

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

### -IsAdmin
If true, the user will be made a SuperAdmin.
If $false, the user will have SuperAdmin privileges revoked.

Requires confirmation.

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

### -Locations
The Location objects of the user

This parameter expects a 'Google.Apis.Admin.Directory.directory_v1.Data.UserLocation\[\]' object type.
You can create objects of this type easily by using the function 'Add-GSUserLocation'

To CLEAR all values for a user, pass \`$null\` as the value for this parameter.

```yaml
Type: UserLocation[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Organizations
The organization objects of the user

This parameter expects a 'Google.Apis.Admin.Directory.directory_v1.Data.UserOrganization\[\]' object type.
You can create objects of this type easily by using the function 'Add-GSUserOrganization'

To CLEAR all values for a user, pass \`$null\` as the value for this parameter.

```yaml
Type: UserOrganization[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OrgUnitPath
The new OrgUnitPath for the user

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

### -Password
The new password for the user as a SecureString

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Phones
The phone objects of the user

This parameter expects a 'Google.Apis.Admin.Directory.directory_v1.Data.UserPhone\[\]' object type.
You can create objects of this type easily by using the function 'Add-GSUserPhone'

To CLEAR all values for a user, pass \`$null\` as the value for this parameter.

```yaml
Type: UserPhone[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrimaryEmail
The new primary email for the user.
The previous primary email will become an alias automatically

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

### -RecoveryEmail
Recovery email of the user.

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

### -RecoveryPhone
Recovery phone of the user.
The phone number must be in the E.164 format, starting with the plus sign (+).
Example: +16506661212.
The value provided for RecoveryPhone is stripped of all non-digit characters and prepended with a + to ensure correct formatting.

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

### -Relations
A list of the user's relationships to other users.

This parameter expects a 'Google.Apis.Admin.Directory.directory_v1.Data.UserRelation\[\]' object type.
You can create objects of this type easily by using the function 'Add-GSUserRelation'

To CLEAR all values for a user, pass \`$null\` as the value for this parameter.

```yaml
Type: UserRelation[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Suspended
If set to $true or passed as a bare switch (-Suspended), user will be suspended.
If set to $false, user will be unsuspended.
If excluded, user's suspension status will remain as-is

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
The primary email or unique Id of the user to update

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Id, UserKey, Mail

Required: True
Position: 1
Default value: None
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

### Google.Apis.Admin.Directory.directory_v1.Data.User
## NOTES

## RELATED LINKS
