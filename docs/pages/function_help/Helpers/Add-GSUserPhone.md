# Add-GSUserPhone

## SYNOPSIS
Builds a UserPhone object to use when creating or updating a User

## SYNTAX

### Fields
```
Add-GSUserPhone [-CustomType <String>] [-Primary] [-Type <String>] [-Value <String>] [<CommonParameters>]
```

### InputObject
```
Add-GSUserPhone [-InputObject <UserAddress[]>] [<CommonParameters>]
```

## DESCRIPTION
Builds a UserPhone object to use when creating or updating a User

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

### -CustomType
If the value of type is custom, this property contains the custom type

```yaml
Type: String
Parameter Sets: Fields
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
Used for pipeline input of an existing UserPhone object to strip the extra attributes and prevent errors

```yaml
Type: UserAddress[]
Parameter Sets: InputObject
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Primary
Indicates if this is the user's primary phone number.
A user may only have one primary phone number

```yaml
Type: SwitchParameter
Parameter Sets: Fields
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
The type of phone number.

Acceptable values are:
* "assistant"
* "callback"
* "car"
* "company_main"
* "custom"
* "grand_central"
* "home"
* "home_fax"
* "isdn"
* "main"
* "mobile"
* "other"
* "other_fax"
* "pager"
* "radio"
* "telex"
* "tty_tdd"
* "work"
* "work_fax"
* "work_mobile"
* "work_pager"

```yaml
Type: String
Parameter Sets: Fields
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value
A human-readable phone number.
It may be in any telephone number format

```yaml
Type: String
Parameter Sets: Fields
Aliases: Phone

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

### Google.Apis.Admin.Directory.directory_v1.Data.UserAddress
## NOTES

## RELATED LINKS
