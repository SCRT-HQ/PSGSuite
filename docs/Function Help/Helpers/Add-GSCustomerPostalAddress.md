# Add-GSCustomerPostalAddress

## SYNOPSIS
Builds a PostalAddress object to use when creating or updating a Customer

## SYNTAX

### InputObject (Default)
```
Add-GSCustomerPostalAddress [-InputObject <CustomerPostalAddress>] [<CommonParameters>]
```

### Fields
```
Add-GSCustomerPostalAddress [-AddressLine1 <String>] [-AddressLine2 <String>] [-AddressLine3 <String>]
 [-ContactName <String>] [-CountryCode <String>] [-Locality <String>] [-OrganizationName <String>]
 [-PostalCode <String>] [-Region <String>] [<CommonParameters>]
```

## DESCRIPTION
Builds a PostalAddress object to use when creating or updating a Customer

## EXAMPLES

### EXAMPLE 1
```
Add-GSCustomerPostalAddress -AddressLine1 '123 Front St' -AddressLine2 'Los Angeles, CA 90210' -ContactName 'Jim'
```

## PARAMETERS

### -AddressLine1
A customer's physical address.
The address can be composed of one to three lines.

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

### -AddressLine2
Address line 2 of the address.

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

### -AddressLine3
Address line 3 of the address.

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

### -ContactName
The customer contact's name.

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

### -InputObject
Used for pipeline input of an existing UserAddress object to strip the extra attributes and prevent errors

```yaml
Type: CustomerPostalAddress
Parameter Sets: InputObject
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Locality
Name of the locality.
An example of a locality value is the city of San Francisco.

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

### -OrganizationName
The company or company division name.

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
The postal code.
A postalCode example is a postal zip code such as 10009.
This is in accordance with - http://portablecontacts.net/draft-spec.html#address_element.

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

### -Region
Name of the region.
An example of a region value is NY for the state of New York.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Admin.Directory.directory_v1.Data.CustomerPostalAddress
## NOTES

## RELATED LINKS
