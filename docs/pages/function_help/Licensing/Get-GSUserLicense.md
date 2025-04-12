# Get-GSUserLicense

## SYNOPSIS
Gets the G Suite license information for a user or list of users

## SYNTAX

### List (Default)
```
Get-GSUserLicense [-License <String>] [-ProductID <String[]>] [-PageSize <Int32>] [-Limit <Int32>]
 [<CommonParameters>]
```

### Get
```
Get-GSUserLicense [[-User] <String[]>] [-License <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets the G Suite license information for a user or list of users

## EXAMPLES

### EXAMPLE 1
```
Get-GSUserLicense
```

Gets the full list of licenses for the customer

## PARAMETERS

### -License
The license SKU to retrieve information for.
If excluded, searches all license SKUs

```yaml
Type: String
Parameter Sets: (All)
Aliases: SkuId

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
The maximum amount of results you want returned.
Exclude or set to 0 to return all results

```yaml
Type: Int32
Parameter Sets: List
Aliases: First

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
The page size of the result set

```yaml
Type: Int32
Parameter Sets: List
Aliases: MaxResults

Required: False
Position: Named
Default value: 1000
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProductID
The product Id to list licenses for

```yaml
Type: String[]
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: @("Google-Apps","Google-Drive-storage","Google-Vault","Cloud-Identity","Cloud-Identity-Premium")
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The primary email or unique Id of the user to retrieve license information for

```yaml
Type: String[]
Parameter Sets: Get
Aliases: PrimaryEmail, UserKey, Mail

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Licensing.v1.Data.LicenseAssignment
## NOTES

## RELATED LINKS
