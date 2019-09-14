# Get-GSShortUrl

## SYNOPSIS
Gets information about a user's Short Url's created at https://goo.gl/

## SYNTAX

```
Get-GSShortUrl [[-ShortUrl] <String[]>] [-User <String[]>] [-Projection <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets information about a user's Short Url's created at https://goo.gl/

## EXAMPLES

### EXAMPLE 1
```
Get-GSShortUrl
```

Gets the Short Url list of the AdminEmail user

## PARAMETERS

### -Projection
Additional information to return.

Acceptable values are:
* "ANALYTICS_CLICKS" - Returns short URL click counts.
* "FULL" - Returns short URL click counts.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Full
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShortUrl
The Short Url to return information for.
If excluded, returns the list of the user's Short Url's

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Id

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -User
The primary email of the user you would like to retrieve Short Url information for

Defaults to the AdminEmail user

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail

Required: False
Position: Named
Default value: $Script:PSGSuite.AdminEmail
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Urlshortener.v1.Data.Url
## NOTES

## RELATED LINKS
