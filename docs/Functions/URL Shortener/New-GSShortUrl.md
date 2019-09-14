# New-GSShortUrl

## SYNOPSIS
Creates a new Short Url

## SYNTAX

```
New-GSShortUrl -LongUrl <String[]> [[-User] <String>] [<CommonParameters>]
```

## DESCRIPTION
Creates a new Short Url

## EXAMPLES

### EXAMPLE 1
```
New-GSShortUrl "http://ferrell.io"
```

Creates a new Short Url pointing at http://ferrell.io/

## PARAMETERS

### -LongUrl
The full Url to shorten

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The user to create the Short Url for

Defaults to the AdminEmail user

```yaml
Type: String
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail

Required: False
Position: 1
Default value: $Script:PSGSuite.AdminEmail
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Urlshortener.v1.Data.Url
## NOTES

## RELATED LINKS
