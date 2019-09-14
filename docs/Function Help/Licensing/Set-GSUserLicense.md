# Set-GSUserLicense

## SYNOPSIS
Sets the license for a user

## SYNTAX

```
Set-GSUserLicense [-User] <String[]> [-License] <String> [<CommonParameters>]
```

## DESCRIPTION
Sets the license for a user

## EXAMPLES

### EXAMPLE 1
```
Set-GSUserLicense -User joe -License Google-Apps-For-Business
```

Sets Joe to a Google-Apps-For-Business license

## PARAMETERS

### -License
The license SKU to set for the user

```yaml
Type: String
Parameter Sets: (All)
Aliases: SkuId

Required: True
Position: 2
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

Required: True
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
