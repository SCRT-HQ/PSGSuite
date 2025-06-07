# Get-GSCustomer

## SYNOPSIS
Retrieves a customer

## SYNTAX

```
Get-GSCustomer [[-CustomerKey] <String>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves a customer

## EXAMPLES

### EXAMPLE 1
```
Get-GSCustomer (Get-GSUser).CustomerId
```

## PARAMETERS

### -CustomerKey
Id of the Customer to be retrieved

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Admin.Directory.directory_v1.Data.Customer
## NOTES

## RELATED LINKS
