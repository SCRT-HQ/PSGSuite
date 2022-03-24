# Get-GSDriveProfile

## SYNOPSIS
Gets Drive profile for the user

## SYNTAX

```
Get-GSDriveProfile [[-User] <String>] [[-Fields] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Gets Drive profile for the user

## EXAMPLES

### EXAMPLE 1
```
Get-GSDriveProfile
```

Gets the Drive profile of the AdminEmail user

## PARAMETERS

### -Fields
The specific fields to request

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: @('AppInstalled','ExportFormats','FolderColorPalette','ImportFormats','Kind','MaxImportSizes','MaxUploadSize','StorageQuota','TeamDriveThemes','User')
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The user to get profile of

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

### Google.Apis.Drive.v3.Data.About
## NOTES

## RELATED LINKS
