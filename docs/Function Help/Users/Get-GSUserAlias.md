# Get-GSUserAlias

## SYNOPSIS
Gets the specified G SUite User's aliases

## SYNTAX

```
Get-GSUserAlias [[-User] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Gets the specified G SUite User's aliases

## EXAMPLES

### EXAMPLE 1
```
Get-GSUserAlias
```

Gets the list of aliases for the AdminEmail user

## PARAMETERS

### -User
The primary email or UserID of the user who you are trying to get aliases for.
You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

Defaults to the AdminEmail in the config

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail, Email

Required: False
Position: 1
Default value: $Script:PSGSuite.AdminEmail
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Admin.Directory.directory_v1.Data.Alias
## NOTES

## RELATED LINKS
