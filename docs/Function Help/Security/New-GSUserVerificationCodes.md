# New-GSUserVerificationCodes

## SYNOPSIS
Generates new verification codes for the user

## SYNTAX

```
New-GSUserVerificationCodes [-User] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Generates new verification codes for the user

## EXAMPLES

### EXAMPLE 1
```
New-GSUserVerificationCodes -User me
```

Generates new verification codes for the AdminEmail user

## PARAMETERS

### -User
The primary email or UserID of the user who you are trying to get info for.
You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config

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

### Google.Apis.Admin.Directory.directory_v1.Data.VerificationCode
## NOTES

## RELATED LINKS
