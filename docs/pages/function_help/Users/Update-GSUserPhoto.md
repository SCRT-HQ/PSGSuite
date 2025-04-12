# Update-GSUserPhoto

## SYNOPSIS
Updates the photo for the specified user

## SYNTAX

```
Update-GSUserPhoto [-User] <String> [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
Updates the photo for the specified user

## EXAMPLES

### EXAMPLE 1
```
Update-GSUserPhoto -User me -Path .\myphoto.png
```

Updates the Google user photo of the AdminEmail with the image at the specified path

## PARAMETERS

### -Path
The path of the photo that you would like to update the user with.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The primary email or UserID of the user who you are trying to update the photo for.
You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

```yaml
Type: String
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail

Required: True
Position: 1
Default value: None
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
