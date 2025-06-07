# Get-GSDrive

## SYNOPSIS
Gets information about a Shared Drive

## SYNTAX

### List (Default)
```
Get-GSDrive [[-User] <String>] [-Filter <String>] [-UseDomainAdminAccess] [-PageSize <Int32>] [-Limit <Int32>]
 [<CommonParameters>]
```

### Get
```
Get-GSDrive [-DriveId <String[]>] [[-User] <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets information about a Shared Drive

## EXAMPLES

### EXAMPLE 1
```
Get-GSDrive -Limit 3 -UseDomainAdminAccess
```

Gets the first 3 Shared Drives in the domain.

## PARAMETERS

### -DriveId
The unique Id of the Shared Drive.
If excluded, the list of Shared Drives will be returned

```yaml
Type: String[]
Parameter Sets: Get
Aliases: Id, TeamDriveId

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Filter
Query string for searching Shared Drives.
See the "Search for Files and Shared Drives" guide for the supported syntax: https://developers.google.com/drive/v3/web/search-parameters

PowerShell filter syntax here is supported as "best effort".
Please use Google's filter operators and syntax to ensure best results

```yaml
Type: String
Parameter Sets: List
Aliases: Q, Query

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
The maximum amount of results you want returned.
Exclude or set to 0 to return all results

```yaml
Type: Int32
Parameter Sets: List
Aliases: First

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
The page size of the result set

```yaml
Type: Int32
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseDomainAdminAccess
Issue the request as a domain administrator; if set to true, then all Shared Drives of the domain in which the requester is an administrator are returned.

```yaml
Type: SwitchParameter
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The email or unique Id of the user with access to the Shared Drive

```yaml
Type: String
Parameter Sets: (All)
Aliases: Owner, PrimaryEmail, UserKey, Mail

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

### Google.Apis.Drive.v3.Data.Drive
## NOTES

## RELATED LINKS
