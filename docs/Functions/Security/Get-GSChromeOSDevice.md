# Get-GSChromeOSDevice

## SYNOPSIS
Gets the list of Chrome OS Devices registered for the user's account

## SYNTAX

### List (Default)
```
Get-GSChromeOSDevice [-Filter <String>] [-OrgUnitPath <String>] [-Projection <String>] [-PageSize <Int32>]
 [-Limit <Int32>] [-OrderBy <String>] [-SortOrder <String>] [<CommonParameters>]
```

### Get
```
Get-GSChromeOSDevice [[-ResourceId] <String[]>] [-Projection <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets the list of Chrome OS Devices registered for the user's account

## EXAMPLES

### EXAMPLE 1
```
Get-GSChromeOSDevice
```

Gets the Chrome OS Device list for the customer

## PARAMETERS

### -Filter
Search string in the format given at: http://support.google.com/chromeos/a/bin/answer.py?answer=1698333

```yaml
Type: String
Parameter Sets: List
Aliases: Query

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

### -OrderBy
Device property to use for sorting results.

Acceptable values are:
* "annotatedLocation": Chrome device location as annotated by the administrator.
* "annotatedUser": Chrome device user as annotated by the administrator.
* "lastSync": The date and time the Chrome device was last synchronized with the policy settings in the Admin console.
* "notes": Chrome device notes as annotated by the administrator.
* "serialNumber": The Chrome device serial number entered when the device was enabled.
* "status": Chrome device status.
For more information, see the chromeosdevices resource.
* "supportEndDate": Chrome device support end date.
This is applicable only for devices purchased directly from Google.

```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OrgUnitPath
The full path of the organizational unit or its unique ID.

```yaml
Type: String
Parameter Sets: List
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
Parameter Sets: List
Aliases: MaxResults

Required: False
Position: Named
Default value: 100
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

### -ResourceId
Immutable ID of Chrome OS Device.
Gets the list of Chrome OS devices if excluded.

```yaml
Type: String[]
Parameter Sets: Get
Aliases: Id, Device, DeviceId

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Admin.Directory.directory_v1.Data.ChromeOSDevice
## NOTES

## RELATED LINKS
