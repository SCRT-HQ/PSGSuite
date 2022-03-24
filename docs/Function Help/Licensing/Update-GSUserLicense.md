# Update-GSUserLicense

## SYNOPSIS
Reassign a user's product SKU with a different SKU in the same product

## SYNTAX

```
Update-GSUserLicense [[-User] <String[]>] [-License <String>] [<CommonParameters>]
```

## DESCRIPTION
Reassign a user's product SKU with a different SKU in the same product

## EXAMPLES

### EXAMPLE 1
```
Update-GSUserLicense -User joe -License G-Suite-Enterprise
```

Updates Joe to a G-Suite-Enterprise license

## PARAMETERS

### -License
The license SKU that you would like to reassign the user to

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

### -User
The user's current primary email address

```yaml
Type: String[]
Parameter Sets: (All)
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
