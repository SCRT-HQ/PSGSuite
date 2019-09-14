# Get-GSToken

## SYNOPSIS
Requests an Access Token for REST API authentication.
Defaults to 3600 seconds token expiration time.

## SYNTAX

```
Get-GSToken [-Scopes] <String[]> [[-AdminEmail] <String>] [<CommonParameters>]
```

## DESCRIPTION
Requests an Access Token for REST API authentication.
Defaults to 3600 seconds token expiration time.

## EXAMPLES

### EXAMPLE 1
```
$Token = Get-GSToken -Scopes 'https://www.google.com/m8/feeds' -AdminEmail $User
```

$headers = @{
    Authorization = "Bearer $($Token)"
    'GData-Version' = '3.0'
}

## PARAMETERS

### -AdminEmail
The email address of the user to request the token for.
This is typically the Admin user.

```yaml
Type: String
Parameter Sets: (All)
Aliases: User

Required: False
Position: 2
Default value: $Script:PSGSuite.AdminEmail
Accept pipeline input: False
Accept wildcard characters: False
```

### -Scopes
The list of scopes to request the token for

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Scope

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
