# Get-GSUserVerificationCodes

## SYNOPSIS
Gets the 2-Step Verification Codes for the user

## SYNTAX

```
Get-GSUserVerificationCodes [[-User] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Gets the 2-Step Verification Codes for the user

## EXAMPLES

### EXAMPLE 1
```
Get-GSUserVerificationCodes
```

Gets the Verification Codes for AdminEmail user

## PARAMETERS

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

### Google.Apis.Admin.Directory.directory_v1.Data.VerificationCode
## NOTES

## RELATED LINKS
