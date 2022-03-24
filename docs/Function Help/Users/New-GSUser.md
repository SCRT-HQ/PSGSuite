# New-GSUser

## SYNOPSIS
Creates a new G Suite user

## SYNTAX

```
New-GSUser [-PrimaryEmail] <String> -GivenName <String> -FamilyName <String> [-FullName <String>]
 -Password <SecureString> [-ChangePasswordAtNextLogin] [-OrgUnitPath <String>] [-Suspended]
 [-Addresses <UserAddress[]>] [-Emails <UserEmail[]>] [-ExternalIds <UserExternalId[]>] [-Ims <UserIm[]>]
 [-Locations <UserLocation[]>] [-Organizations <UserOrganization[]>] [-Relations <UserRelation[]>]
 [-Phones <UserPhone[]>] [-IncludeInGlobalAddressList] [-IpWhitelisted] [-CustomSchemas <Hashtable>]
 [<CommonParameters>]
```

## DESCRIPTION
Creates a new G Suite user

## EXAMPLES

### EXAMPLE 1
```
$address = Add-GSUserAddress -Country USA -Locality Dallas -PostalCode 75000 Region TX -StreetAddress '123 South St' -Type Work -Primary
```

$phone = Add-GSUserPhone -Type Work -Value "(800) 873-0923" -Primary

$extId = Add-GSUserExternalId -Type Login_Id -Value jsmith2

$email = Add-GSUserEmail -Type work -Address jsmith@contoso.com

New-GSUser -PrimaryEmail john.smith@domain.com -GivenName John -FamilyName Smith -Password (ConvertTo-SecureString -String 'Password123' -AsPlainText -Force) -ChangePasswordAtNextLogin -OrgUnitPath "/Users/New Hires" -IncludeInGlobalAddressList -Addresses $address -Phones $phone -ExternalIds $extId -Emails $email

Creates a user named John Smith and adds their work address, work phone, login_id and alternate non gsuite work email to the user object.

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
If set, user will need to change their password on their first login

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

The Custom Schema and it's fields **MUST** exist prior to updating these values for a user otherwise it will return an error.

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
The family (last) name of the user

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

### -FullName
The full name of the user, if different from "$FirstName $LastName"

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

### -GivenName
The given (first) name of the user

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

### -Ims
The IM objects of the user

This parameter expects a 'Google.Apis.Admin.Directory.directory_v1.Data.UserIm\[\]' object type.
You can create objects of this type easily by using the function 'Add-GSUserIm'

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

### -Locations
The Location objects of the user

This parameter expects a 'Google.Apis.Admin.Directory.directory_v1.Data.UserLocation\[\]' object type.
You can create objects of this type easily by using the function 'Add-GSUserLocation'

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
The OrgUnitPath to create the user in

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
The password for the user.
Requires a SecureString

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Phones
The phone objects of the user

This parameter expects a 'Google.Apis.Admin.Directory.directory_v1.Data.UserPhone\[\]' object type.
You can create objects of this type easily by using the function 'Add-GSUserPhone'

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
The primary email for the user.
If a user with the desired email already exists, a GoogleApiException will be thrown

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

### -Relations
The relation objects of the user

This parameter expects a 'Google.Apis.Admin.Directory.directory_v1.Data.UserRelation\[\]' object type.
You can create objects of this type easily by using the function 'Add-GSUserRelation'

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
If set, user will be created in a suspended state

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Admin.Directory.directory_v1.Data.User
## NOTES

## RELATED LINKS
