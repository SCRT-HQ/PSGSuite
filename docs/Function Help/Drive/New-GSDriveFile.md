# New-GSDriveFile

## SYNOPSIS
Creates a blank Drive file

## SYNTAX

### BuiltIn (Default)
```
New-GSDriveFile [[-User] <String>] -Name <String> [-Description <String>] [-FolderColorRgb <String>]
 [-Parents <String[]>] -MimeType <String> [-Projection <String>] [-Fields <String[]>] [<CommonParameters>]
```

### Custom
```
New-GSDriveFile [[-User] <String>] -Name <String> [-Description <String>] [-FolderColorRgb <String>]
 [-Parents <String[]>] -CustomMimeType <String> [-Projection <String>] [-Fields <String[]>]
 [<CommonParameters>]
```

## DESCRIPTION
Creates a blank Drive file

## EXAMPLES

### EXAMPLE 1
```
New-GSDriveFile -Name "Training Docs" -MimeType DriveFolder
```

Creates a new folder in Drive named "Training Docs" in the root OrgUnit for the AdminEmail user

## PARAMETERS

### -CustomMimeType
The custom Mime Type of the new Drive file

```yaml
Type: String
Parameter Sets: Custom
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
The description of the Drive file

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

### -Fields
The specific fields to returned

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

### -FolderColorRgb
The color for a folder as an RGB hex string.

Available values are:
* "ChocolateIceCream"
* "OldBrickRed"
* "Cardinal"
* "WildStrawberries"
* "MarsOrange"
* "YellowCab"
* "Spearmint"
* "VernFern"
* "Asparagus"
* "SlimeGreen"
* "DesertSand"
* "Macaroni"
* "SeaFoam"
* "Pool"
* "Denim"
* "RainySky"
* "BlueVelvet"
* "PurpleDino"
* "Mouse"
* "MountainGrey"
* "Earthworm"
* "BubbleGum"
* "PurpleRain"
* "ToyEggplant"

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

### -MimeType
The Google Mime Type of the new Drive file

Available values are:
* "Audio"
* "Docs"
* "Drawing"
* "DriveFile"
* "DriveFolder"
* "Form"
* "FusionTables"
* "Map"
* "Photo"
* "Slides"
* "AppsScript"
* "Sites"
* "Sheets"
* "Unknown"
* "Video"

```yaml
Type: String
Parameter Sets: BuiltIn
Aliases: Type

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the new Drive file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Parents
The parent folder Id of the new Drive file

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: ParentId

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Projection
The defined subset of fields to be returned

Available values are:
* "Minimal"
* "Standard"
* "Full"
* "Access"

```yaml
Type: String
Parameter Sets: (All)
Aliases: Depth

Required: False
Position: Named
Default value: Full
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The email or unique Id of the user who you are creating the Drive file for

Defaults to the AdminEmail user

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

### Google.Apis.Drive.v3.Data.File
## NOTES

## RELATED LINKS
