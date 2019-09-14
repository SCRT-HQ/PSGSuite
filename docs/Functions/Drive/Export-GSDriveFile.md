# Export-GSDriveFile

## SYNOPSIS
Exports a Drive file as if you chose "Export" from the File menu when viewing the file

## SYNTAX

### Depth (Default)
```
Export-GSDriveFile [-FileID] <String> [-User <String>] -Type <String> [-OutFilePath <String>]
 [-Projection <String>] [-Force] [<CommonParameters>]
```

### Fields
```
Export-GSDriveFile [-FileID] <String> [-User <String>] -Type <String> [-OutFilePath <String>]
 [-Fields <String[]>] [-Force] [<CommonParameters>]
```

## DESCRIPTION
Exports a Drive file as if you chose "Export" from the File menu when viewing the file

## EXAMPLES

### EXAMPLE 1
```
Export-GSDriveFile -FileId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976' -Type CSV -OutFilePath .\SheetExport.csv
```

Exports the Drive file as a CSV to the current working directory

## PARAMETERS

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

### -FileID
The unique Id of the file to export

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

### -Force
If $true, overwrites any existing files at the same path.

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

### -OutFilePath
The directory path that you would like to export the Drive file to

Defaults to the current working directory

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

### -Type
The type of local file you would like to export the Drive file as

Available values are:
* "CSV"
* "HTML"
* "JPEG"
* "JSON"
* "MSExcel"
* "MSPowerPoint"
* "MSWordDoc"
* "OpenOfficeDoc"
* "OpenOfficeSheet"
* "PDF"
* "PlainText"
* "PNG"
* "RichText"
* "SVG"

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

### -User
The email or unique Id of the owner of the Drive file

Defaults to the AdminEmail user

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
