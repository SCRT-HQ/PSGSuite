# Get-GSUserASP

## SYNOPSIS
Gets Application Specific Passwords for a user

## SYNTAX

```
Get-GSUserASP [[-User] <String[]>] [[-CodeId] <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets Application Specific Passwords for a user

## EXAMPLES

### EXAMPLE 1
```
Get-GSUserASP
```

Gets the list of Application Specific Passwords for the user

## PARAMETERS

### -CodeId
The ID of the ASP you would like info for.
If excluded, returns the full list of ASP's for the user

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

### Google.Apis.Admin.Directory.directory_v1.Data.Asp
## NOTES

## RELATED LINKS
