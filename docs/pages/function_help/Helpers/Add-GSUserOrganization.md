# Add-GSUserOrganization

## SYNOPSIS
Builds a Organization object to use when creating or updating a User

## SYNTAX

### InputObject (Default)
```
Add-GSUserOrganization [-InputObject <UserOrganization[]>] [<CommonParameters>]
```

### Fields
```
Add-GSUserOrganization [-CostCenter <String>] [-CustomType <String>] [-Department <String>]
 [-Description <String>] [-Domain <String>] [-FullTimeEquivalent <Int32>] [-Location <String>] [-Name <String>]
 [-Primary] [-Symbol <String>] [-Title <String>] [-Type <String>] [<CommonParameters>]
```

## DESCRIPTION
Builds a Organization object to use when creating or updating a User

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

### -CostCenter
The cost center of the users department

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
If the external ID type is custom, this property holds the custom type

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

### -Department
Department within the organization

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

### -Description
Description of the organization

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

### -Domain
The domain to which the organization belongs to

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

### -FullTimeEquivalent
The full-time equivalent percent within the organization (100000 = 100%).

```yaml
Type: Int32
Parameter Sets: Fields
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
Used for pipeline input of an existing UserExternalId object to strip the extra attributes and prevent errors

```yaml
Type: UserOrganization[]
Parameter Sets: InputObject
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Location
Location of the organization.
This need not be fully qualified address.

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

### -Name
Name of the organization

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
If it is the user's primary organization

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

### -Symbol
Symbol of the organization

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

### -Title
Title (designation) of the user in the organization

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
The type of the organization.

If using a CustomType

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

### Google.Apis.Admin.Directory.directory_v1.Data.UserOrganization
## NOTES

## RELATED LINKS
