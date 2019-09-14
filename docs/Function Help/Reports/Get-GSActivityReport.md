# Get-GSActivityReport

## SYNOPSIS
Retrieves a list of activities

## SYNTAX

```
Get-GSActivityReport [[-UserKey] <String>] [[-ApplicationName] <String>] [[-EventName] <String>]
 [-StartTime <DateTime>] [-EndTime <DateTime>] [-ActorIpAddress <String>] [-Filters <String[]>]
 [-PageSize <Int32>] [-Limit <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves a list of activities

## EXAMPLES

### EXAMPLE 1
```
Get-GSActivityReport -StartTime (Get-Date).AddDays(-30)
```

Gets the admin activity report for the last 30 days

## PARAMETERS

### -ActorIpAddress
IP Address of host where the event was performed.
Supports both IPv4 and IPv6 addresses

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

### -ApplicationName
Application name for which the events are to be retrieved.

Available values are:
* "Admin": The Admin console application's activity reports return account information about different types of administrator activity events.
* "Calendar": The G Suite Calendar application's activity reports return information about various Calendar activity events.
* "Drive": The Google Drive application's activity reports return information about various Google Drive activity events.
The Drive activity report is only available for G Suite Business customers.
* "Groups": The Google Groups application's activity reports return information about various Groups activity events.
* "GPlus": The Google+ application's activity reports return information about various Google+ activity events.
* "Login": The G Suite Login application's activity reports return account information about different types of Login activity events.
* "Mobile": The G Suite Mobile Audit activity report return information about different types of Mobile Audit activity events.
* "Rules": The G Suite Rules activity report return information about different types of Rules activity events.
* "Token": The G Suite Token application's activity reports return account information about different types of Token activity events.

Defaults to "Admin"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Admin
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndTime
Return events which occurred at or before this time

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EventName
The name of the event being queried

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filters
Event parameters in the form \[parameter1 name\]\[operator\]\[parameter1 value\]

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

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
Parameter Sets: (All)
Aliases: First

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
Number of activity records to be shown in each page

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: MaxResults

Required: False
Position: Named
Default value: 1000
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartTime
Return events which occurred after this time

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserKey
Represents the profile id or the user email for which the data should be filtered.
When 'all' is specified as the userKey, it returns usageReports for all users

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: All
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Admin.Reports.reports_v1.Data.Activity
## NOTES

## RELATED LINKS
