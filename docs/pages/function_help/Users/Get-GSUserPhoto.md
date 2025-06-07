# Get-GSUserPhoto

## SYNOPSIS
Gets the photo data for the specified user

## SYNTAX

```
Get-GSUserPhoto [[-User] <String[]>] [-OutFilePath <String>] [-OutFileFormat <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets the photo data for the specified user

## EXAMPLES

### EXAMPLE 1
```
Get-GSUserPhoto -OutFilePath .
```

Saves the Google user photo of the AdminEmail in the current working directory as a .png image

## PARAMETERS

### -OutFileFormat
The format that you would like to save the photo as.

Available values are:
* "PNG": saves the photo in .png format
* "JPG": saves the photo in .jpg format
* "Base64": saves the photo as a .txt file containing standard (non-WebSafe) Base64 content.

Defaults to PNG

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: PNG
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutFilePath
The directory path that you would like to save the photos to.
If excluded, this will return the photo information

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

### -User
The primary email or UserID of the user who you are trying to get info for.
You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

Defaults to the AdminEmail in the config

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail

Required: False
Position: 1
Default value: $Script:PSGSuite.AdminEmail
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Admin.Directory.directory_v1.Data.UserPhoto
## NOTES

## RELATED LINKS
