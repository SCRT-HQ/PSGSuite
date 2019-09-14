# New-GoogleService

## SYNOPSIS
Creates a new Google Service object that handles authentication for the scopes specified

## SYNTAX

```
New-GoogleService [-Scope] <String[]> [-ServiceType] <String> [[-User] <String>] [<CommonParameters>]
```

## DESCRIPTION
Creates a new Google Service object that handles authentication for the scopes specified

## EXAMPLES

### EXAMPLE 1
```
$serviceParams = @{
```

Scope       = 'https://www.googleapis.com/auth/admin.reports.audit.readonly'
    ServiceType = 'Google.Apis.Admin.Reports.reports_v1.ReportsService'
}
$service = New-GoogleService @serviceParams

## PARAMETERS

### -Scope
The scope or scopes to build the service with, e.g.
https://www.googleapis.com/auth/admin.reports.audit.readonly

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceType
The type of service to create, e.g.
Google.Apis.Admin.Reports.reports_v1.ReportsService

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The user to request the service for during the authentication process

```yaml
Type: String
Parameter Sets: (All)
Aliases: AdminEmail

Required: False
Position: 3
Default value: $script:PSGSuite.AdminEmail
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
