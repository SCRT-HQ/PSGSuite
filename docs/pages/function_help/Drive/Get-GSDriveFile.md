# Get-GSDriveFile

## SYNOPSIS
Gets information about or downloads a Drive file

## SYNTAX

### Depth (Default)
```
Get-GSDriveFile [-FileId] <String[]> [-User <String>] [-OutFilePath <String>] [-Projection <String>] [-Force]
 [<CommonParameters>]
```

### Fields
```
Get-GSDriveFile [-FileId] <String[]> [-User <String>] [-OutFilePath <String>] [-Fields <String[]>] [-Force]
 [<CommonParameters>]
```

## DESCRIPTION
Gets information about or downloads a Drive file

## EXAMPLES

### EXAMPLE 1
```
Get-GSDriveFile -FileId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976'
```

Gets the information for the file

### EXAMPLE 2
```
Get-GSDriveFile -FileId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976' -OutFilePath (Get-Location).Path
```

Gets the information for the file and saves the file in the current working directory

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

### -FileId
The unique Id of the file to get

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
If $true and OutFilePath is specified, overwrites any existing files at the desired path.

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
The directory path that you would like to download the Drive file to.
If excluded, only the Drive file information will be returned

```yaml
Type: String
Parameter Sets: (All)
Aliases: SaveFileTo

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Projection
The defined subset of fields to be returned

Available values are:
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

### Google.Apis.Drive.v3.Data.File
## NOTES

## RELATED LINKS
