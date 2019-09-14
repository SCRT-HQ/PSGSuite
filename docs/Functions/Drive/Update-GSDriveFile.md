# Update-GSDriveFile

## SYNOPSIS
Updates the metadata for a Drive file

## SYNTAX

### Depth (Default)
```
Update-GSDriveFile [-FileId] <String> [[-Path] <String>] [-Name <String>] [-Description <String>]
 [-FolderColorRgb <String>] [-AddParents <String[]>] [-RemoveParents <String[]>]
 [-CopyRequiresWriterPermission] [-Starred] [-Trashed] [-WritersCanShare] [-Projection <String>]
 [-User <String>] [<CommonParameters>]
```

### Fields
```
Update-GSDriveFile [-FileId] <String> [[-Path] <String>] [-Name <String>] [-Description <String>]
 [-FolderColorRgb <String>] [-AddParents <String[]>] [-RemoveParents <String[]>]
 [-CopyRequiresWriterPermission] [-Starred] [-Trashed] [-WritersCanShare] [-Fields <String[]>] [-User <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Updates the metadata for a Drive file

## EXAMPLES

### EXAMPLE 1
```
Update-GSDriveFile -FileId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976' -Name "To-Do Progress"
```

Updates the Drive file with a new name, "To-Do Progress"

### EXAMPLE 2
```
Update-GSDriveFile -FileId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976' -Path "C:\Pics\NewPic.png"
```

Updates the Drive file with the content of the file at that path.
In this example, the Drive file is a PNG named "Test.png".
This will change the content of the file in Drive to match NewPic.png as well as rename it to "NewPic.png"

## PARAMETERS

### -AddParents
The parent Ids to add

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

### -CopyRequiresWriterPermission
Whether the options to copy, print, or download this file, should be disabled for readers and commenters.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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
Parameter Sets: Fields
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileId
The unique Id of the Drive file to Update

```yaml
Type: String
Parameter Sets: (All)
Aliases: Id

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
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

### -Name
The name of the Drive file

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

### -Path
The path to the local file whose content you would like to upload to Drive.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
Parameter Sets: Depth
Aliases: Depth

Required: False
Position: Named
Default value: Full
Accept pipeline input: False
Accept wildcard characters: False
```

### -RemoveParents
The parent Ids to remove

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

### -Starred
Whether the user has starred the file.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Trashed
Whether the file has been trashed, either explicitly or from a trashed parent folder.

Only the owner may trash a file, and other users cannot see files in the owner's trash.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The email or unique Id of the Drive file owner

```yaml
Type: String
Parameter Sets: (All)
Aliases: Owner, PrimaryEmail, UserKey, Mail

Required: False
Position: Named
Default value: $Script:PSGSuite.AdminEmail
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WritersCanShare
If $true, sets Writers Can Share to true on the file.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Drive.v3.Data.File
## NOTES

## RELATED LINKS
