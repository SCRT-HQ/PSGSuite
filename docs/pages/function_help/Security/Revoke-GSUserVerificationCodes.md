# Revoke-GSUserVerificationCodes

## SYNOPSIS
Revokes/invalidates Verification Codes for the user

## SYNTAX

```
Revoke-GSUserVerificationCodes [[-User] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Revokes/invalidates Verification Codes for the user

## EXAMPLES

### EXAMPLE 1
```
Revoke-GSUserVerificationCodes -User me -Confirm:$false
```

Invalidates the verification codes for the AdminEmail user, skipping confirmation

## PARAMETERS

### -User
The user to revoke verification codes from

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

## NOTES

## RELATED LINKS
