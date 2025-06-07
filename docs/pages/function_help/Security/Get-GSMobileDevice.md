# Get-GSMobileDevice

## SYNOPSIS
Gets the list of Mobile Devices registered for the user's account

## SYNTAX

### User (Default)
```
Get-GSMobileDevice [[-User] <String[]>] [-Projection <String>] [-PageSize <Int32>] [-Limit <Int32>]
 [-OrderBy <String>] [-SortOrder <String>] [<CommonParameters>]
```

### Query
```
Get-GSMobileDevice [[-Filter] <String>] [-Projection <String>] [-PageSize <Int32>] [-Limit <Int32>]
 [-OrderBy <String>] [-SortOrder <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets the list of Mobile Devices registered for the user's account

## EXAMPLES

### EXAMPLE 1
```
Get-GSMobileDevice
```

Gets the Mobile Device list for the AdminEmail

## PARAMETERS

### -Filter
Search string in the format given at: http://support.google.com/a/bin/answer.py?hl=en&answer=1408863#search

```yaml
Type: String
Parameter Sets: Query
Aliases: Query

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
The maximum amount of results you want returned.
Exclude or set to 0 to return all results

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: First

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -OrderBy
Device property to use for sorting results.

Acceptable values are:
* "deviceId": The serial number for a Google Sync mobile device.
For Android devices, this is a software generated unique identifier.
* "email": The device owner's email address.
* "lastSync": Last policy settings sync date time of the device.
* "model": The mobile device's model.
* "name": The device owner's user name.
* "os": The device's operating system.
* "status": The device status.
* "type": Type of the device.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
Page size of the result set

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1000
Accept pipeline input: False
Accept wildcard characters: False
```

### -Projection
Restrict information returned to a set of selected fields.

Acceptable values are:
* "BASIC": Includes only the basic metadata fields (e.g., deviceId, model, status, type, and status)
* "FULL": Includes all metadata fields

Defauls to "FULL"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: FULL
Accept pipeline input: False
Accept wildcard characters: False
```

### -SortOrder
Whether to return results in ascending or descending order.
Must be used with the OrderBy parameter.

Acceptable values are:
* "ASCENDING": Ascending order.
* "DESCENDING": Descending order.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The user that you would like to retrieve the Mobile Device list for.
If no user is specified, it will list all of the Mobile Devices of the CustomerID

```yaml
Type: String[]
Parameter Sets: User
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

### Google.Apis.Admin.Directory.directory_v1.Data.MobileDevice
## NOTES

## RELATED LINKS
