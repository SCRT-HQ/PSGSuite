# New-GSResource

## SYNOPSIS
Creates a new Calendar Resource

## SYNTAX

### Features (Default)
```
New-GSResource [-Name] <String> [-Resource <String>] [<CommonParameters>]
```

### Calendars
```
New-GSResource [-Name] <String> [-Id <String>] [-BuildingId <String>] [-Description <String>]
 [-Capacity <Int32>] [-FloorName <String>] [-FloorSection <String>] [-Category <String>]
 [-ResourceType <String>] [-UserVisibleDescription <String>] [-Resource <String>] [<CommonParameters>]
```

### Buildings
```
New-GSResource [-Name] <String> [-BuildingId <String>] [-Description <String>] [-FloorNames <String[]>]
 [-Resource <String>] [<CommonParameters>]
```

## DESCRIPTION
Creates a new Calendar Resource.
Supports Resource types 'Calendars','Buildings' & 'Features'

## EXAMPLES

### EXAMPLE 1
```
New-GSResource -Name "Training Room" -Id "Train01" -Capacity 75 -Category 'CONFERENCE_ROOM' -ResourceType "Conference Room" -Description "Training room for new hires - has 1 LAN port per station" -UserVisibleDescription "Training room for new hires"
```

Creates a new training room Resource Calendar that will be bookable on Google Calendar

## PARAMETERS

### -BuildingId
Unique ID for the building a resource is located in.

```yaml
Type: String
Parameter Sets: Calendars, Buildings
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Capacity
Capacity of a resource, number of seats in a room.

```yaml
Type: Int32
Parameter Sets: Calendars
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Category
The category of the calendar resource.
Either CONFERENCE_ROOM or OTHER.
Legacy data is set to CATEGORY_UNKNOWN. 

Acceptable values are:
* "CATEGORY_UNKNOWN"
* "CONFERENCE_ROOM"
* "OTHER"

Defaults to 'CATEGORY_UNKNOWN' if creating a Calendar Resource

```yaml
Type: String
Parameter Sets: Calendars
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Description of the resource, visible only to admins.

```yaml
Type: String
Parameter Sets: Calendars, Buildings
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FloorName
Name of the floor a resource is located on (Calendars Resource type)

```yaml
Type: String
Parameter Sets: Calendars
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FloorNames
The names of the floors in the building (Buildings Resource type)

```yaml
Type: String[]
Parameter Sets: Buildings
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FloorSection
Name of the section within a floor a resource is located in.

```yaml
Type: String
Parameter Sets: Calendars
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
The unique ID for the calendar resource.

```yaml
Type: String
Parameter Sets: Calendars
Aliases: ResourceId

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the new Resource

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Resource
The resource type you would like to create

Available values are:
* "Calendars": create a Resource Calendar or legacy resource type
* "Buildings": create a Resource Building
* "Features": create a Resource Feature

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

### -ResourceType
The type of the calendar resource, intended for non-room resources.

```yaml
Type: String
Parameter Sets: Calendars
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserVisibleDescription
Description of the resource, visible to users and admins.

```yaml
Type: String
Parameter Sets: Calendars
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

## NOTES

## RELATED LINKS
