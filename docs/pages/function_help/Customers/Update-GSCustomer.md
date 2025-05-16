# Update-GSCustomer

## SYNOPSIS
Updates a customer using patch semantics.

## SYNTAX

```
Update-GSCustomer [[-CustomerKey] <String>] [-AlternateEmail <String>] [-CustomerDomain <String>]
 [-Language <String>] [-PhoneNumber <String>] [-PostalAddress <CustomerPostalAddress>] [<CommonParameters>]
```

## DESCRIPTION
Updates a customer using patch semantics.

## EXAMPLES

### EXAMPLE 1
```
Get-GSCustomer (Get-GSUser).CustomerId
```

## PARAMETERS

### -AlternateEmail
The customer's secondary contact email address.
This email address cannot be on the same domain as the customerDomain.

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

### -CustomerDomain
The customer's primary domain name string.
Do not include the www prefix when creating a new customer.

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

### -CustomerKey
Id of the Customer to be updated.

```yaml
Type: String
Parameter Sets: (All)
Aliases: CustomerId

Required: False
Position: 1
Default value: $Script:PSGSuite.CustomerId
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Language
The customer's ISO 639-2 language code.
The default value is en-US.

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

### -PhoneNumber
The customer's contact phone number in E.164 format.

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

### -PostalAddress
The customer's postal address information.

Must be type \[Google.Apis.Admin.Directory.directory_v1.Data.CustomerPostalAddress\].
Use helper function Add-GSCustomerPostalAddress to create the correct type easily.

```yaml
Type: CustomerPostalAddress
Parameter Sets: (All)
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

### Google.Apis.Admin.Directory.directory_v1.Data.Customer
## NOTES

## RELATED LINKS
