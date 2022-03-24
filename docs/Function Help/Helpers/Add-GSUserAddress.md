# Add-GSUserAddress

## SYNOPSIS
Builds a UserAddress object to use when creating or updating a User

## SYNTAX

### InputObject (Default)
```
Add-GSUserAddress [-InputObject <UserAddress[]>] [<CommonParameters>]
```

### Fields
```
Add-GSUserAddress [-Country <String>] [-CountryCode <String>] [-CustomType <String>]
 [-ExtendedAddress <String>] [-Formatted <String>] [-Locality <String>] [-PoBox <String>]
 [-PostalCode <String>] [-Primary] [-Region <String>] [-SourceIsStructured] [-StreetAddress <String>]
 [-Type <String>] [<CommonParameters>]
```

## DESCRIPTION
Builds a UserAddress object to use when creating or updating a User

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

### -Country
Country

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

### -CountryCode
The country code.
Uses the ISO 3166-1 standard: http://www.iso.org/iso/iso-3166-1_decoding_table

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

### -CustomType
If the address type is custom, this property contains the custom value

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

### -ExtendedAddress
For extended addresses, such as an address that includes a sub-region

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

### -Formatted
A full and unstructured postal address.
This is not synced with the structured address fields

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
Used for pipeline input of an existing UserAddress object to strip the extra attributes and prevent errors

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

### -Locality
The town or city of the address

```yaml
Type: String
Parameter Sets: Fields
Aliases: Town, City

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PoBox
The post office box, if present

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

### -PostalCode
The ZIP or postal code, if applicable

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

### -Primary
If this is the user's primary address.
The addresses list may contain only one primary address

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

### -Region
The abbreviated province or state

```yaml
Type: String
Parameter Sets: Fields
Aliases: State, Province

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourceIsStructured
Indicates if the user-supplied address was formatted.
Formatted addresses are not currently supported

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

### -StreetAddress
The street address, such as 1600 Amphitheatre Parkway.
Whitespace within the string is ignored; however, newlines are significant

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

### -Type
The address type.

Acceptable values are:
* "custom"
* "home"
* "other"
* "work"

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Admin.Directory.directory_v1.Data.UserAddress
## NOTES

## RELATED LINKS
