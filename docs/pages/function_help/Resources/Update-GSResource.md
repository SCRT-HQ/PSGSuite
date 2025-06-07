# Update-GSResource

## SYNOPSIS
Updates a Calendar Resource

## SYNTAX

### Calendars
```
Update-GSResource [-ResourceId] <String> [-BuildingId <String>] [[-Name] <String>] [-Id <String>]
 [-Description <String>] [-Capacity <Int32>] [-FloorName <String>] [-FloorSection <String>]
 [-Category <String>] [-ResourceType <String>] [-UserVisibleDescription <String>] [-Resource <String>]
 [<CommonParameters>]
```

### Buildings
```
Update-GSResource -BuildingId <String> [[-Name] <String>] [-Description <String>] [-FloorNames <String[]>]
 [-Resource <String>] [<CommonParameters>]
```

### Features
```
Update-GSResource [-FeatureKey] <String> [[-Name] <String>] [-Resource <String>] [<CommonParameters>]
```

## DESCRIPTION
Updates a Calendar Resource

## EXAMPLES

### EXAMPLE 1
```
Update-GSResource -ResourceId Train01 -Id TrainingRoom01
```

Updates the resource Id 'Train01' to the new Id 'TrainingRoom01'

## PARAMETERS

### -BuildingId
If updating a Resource Building, the unique Id of the building you would like to update

If updating a Resource Calendar, the new Building Id for the resource

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

```yaml
Type: String
Parameter Sets: Buildings
Aliases:

Required: True
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
The new category of the calendar resource.
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

### -FeatureKey
The unique key of the Feature you would like to update

```yaml
Type: String
Parameter Sets: Features
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
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
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The new name of the resource

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
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

### -ResourceId
The unique Id of the Resource Calendar that you would like to update

```yaml
Type: String
Parameter Sets: Calendars
Aliases: CalendarResourceId

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
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
