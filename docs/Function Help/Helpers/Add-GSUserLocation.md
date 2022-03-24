# Add-GSUserLocation

## SYNOPSIS
Builds a Location object to use when creating or updating a User

## SYNTAX

### Fields
```
Add-GSUserLocation [-Area <String>] [-BuildingId <String>] [-CustomType <String>] [-DeskCode <String>]
 [-FloorName <String>] [-FloorSection <String>] [-Type <String>] [<CommonParameters>]
```

### InputObject
```
Add-GSUserLocation [-InputObject <UserLocation[]>] [<CommonParameters>]
```

## DESCRIPTION
Builds a Location object to use when creating or updating a User

## EXAMPLES

### EXAMPLE 1
```
Add-GSUserLocation -Area "Bellevue, WA" -BuildingId '30' -CustomType "LemonadeStand" -Type custom
```

Adds a custom user location.

## PARAMETERS

### -Area
Textual location.
This is most useful for display purposes to concisely describe the location.
For example, "Mountain View, CA", "Near Seattle", "US-NYC-9TH 9A209A"

```yaml
Type: String
Parameter Sets: Fields
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BuildingId
Building Identifier.

```yaml
Type: String
Parameter Sets: Fields
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomType
Custom Type.

```yaml
Type: String
Parameter Sets: Fields
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeskCode
Most specific textual code of individual desk location.

```yaml
Type: String
Parameter Sets: Fields
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FloorName
Floor name/number.

```yaml
Type: String
Parameter Sets: Fields
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FloorSection
Floor section.
More specific location within the floor.
For example, if a floor is divided into sections "A", "B", and "C", this field would identify one of those values.

```yaml
Type: String
Parameter Sets: Fields
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
Used for pipeline input of an existing Location object to strip the extra attributes and prevent errors

```yaml
Type: UserLocation[]
Parameter Sets: InputObject
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Type
Each entry can have a type which indicates standard types of that entry.
For example location could be of types default and desk.
In addition to standard type, an entry can have a custom type and can give it any name.
Such types should have "custom" as type and also have a customType value.

Acceptable values are:
* "custom"
* "default"
* "desk"

```yaml
Type: String
Parameter Sets: Fields
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

### Google.Apis.Admin.Directory.directory_v1.Data.UserLocation
## NOTES

## RELATED LINKS
