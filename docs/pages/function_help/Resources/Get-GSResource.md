# Get-GSResource

## SYNOPSIS
Gets Calendar Resources (Calendars, Buildings & Features supported)

## SYNTAX

### List (Default)
```
Get-GSResource [[-Resource] <String>] [-Filter <String[]>] [-OrderBy <String[]>] [-PageSize <Int32>]
 [-Limit <Int32>] [<CommonParameters>]
```

### Get
```
Get-GSResource [-Id] <String[]> [[-Resource] <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets Calendar Resources (Calendars, Buildings & Features supported)

## EXAMPLES

### EXAMPLE 1
```
Get-GSResource -Resource Buildings
```

Gets the full list of Buildings Resources

## PARAMETERS

### -Filter
String query used to filter results.
Should be of the form "field operator value" where field can be any of supported fields and operators can be any of supported operations.
Operators include '=' for exact match and ':' for prefix match or HAS match where applicable.
For prefix match, the value should always be followed by a *.
Supported fields include generatedResourceName, name, buildingId, featureInstances.feature.name.
For example buildingId=US-NYC-9TH AND featureInstances.feature.name:Phone.

PowerShell filter syntax here is supported as "best effort".
Please use Google's filter operators and syntax to ensure best results

```yaml
Type: String[]
Parameter Sets: List
Aliases: Query

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
If Id is provided, gets the Resource by Id

```yaml
Type: String[]
Parameter Sets: Get
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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
Field(s) to sort results by in either ascending or descending order.
Supported fields include resourceId, resourceName, capacity, buildingId, and floorName.

```yaml
Type: String[]
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
Default value: 500
Accept pipeline input: False
Accept wildcard characters: False
```

### -Resource
The Resource Type to List

Available values are:
* "Calendars": resource calendars (legacy and new - i.e.
conference rooms)
* "Buildings": new Building Resources (i.e.
"Building A" or "North Campus")
* "Features": new Feature Resources (i.e.
"Video Conferencing" or "Projector")

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Calendars
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
