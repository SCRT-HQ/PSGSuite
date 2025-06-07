# Get-GSUserToken

## SYNOPSIS
Gets security tokens for a user

## SYNTAX

```
Get-GSUserToken [[-User] <String[]>] [[-ClientId] <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets security tokens for a user

## EXAMPLES

### EXAMPLE 1
```
Get-GSUserToken -ClientId "Google Chrome"
```

Gets the token info for "Google Chrome" for the AdminEmail user

## PARAMETERS

### -ClientId
The Id of the client you are trying to get token info for.
If excluded, gets the full list of tokens for the user

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -User
The primary email or UserID of the user who you are trying to get info for.
You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

Defaults to the AdminEmail in the config

```yaml
Type: String[]
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

### Google.Apis.Admin.Directory.directory_v1.Data.Token
## NOTES

## RELATED LINKS
