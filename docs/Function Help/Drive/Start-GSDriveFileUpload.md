# Start-GSDriveFileUpload

## SYNOPSIS
Starts uploading a file or list of files to Drive asynchronously

## SYNTAX

```
Start-GSDriveFileUpload [-Path] <String[]> [-Name <String>] [-Description <String>] [-Parents <String[]>]
 [-Recurse] [-Wait] [-RetryCount <Int32>] [-ThrottleLimit <Int32>] [-User <String>] [<CommonParameters>]
```

## DESCRIPTION
Starts uploading a file or list of files to Drive asynchronously.
Allows full folder structure uploads by passing a folder as -Path and including the -Recurse parameter

## EXAMPLES

### EXAMPLE 1
```
Start-GSDriveFileUpload -Path "C:\Scripts","C:\Modules" -Recurse -Wait
```

Starts uploading the Scripts and Modules folders and the files within them and waits for the uploads to complete, showing progress as files are uploaded

## PARAMETERS

### -Description
The description of the file or folder in Drive

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
The new name of the file once uploaded

Defaults to the existing name of the file or folder

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

### -Parents
The unique Id of the parent folder in Drive to upload the file to

Defaults to the root folder in My Drive

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

### -Path
The path of the file or folder to upload

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: FullName

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Recurse
If $true and there is a Directory passed to -Path, this will rebuild the folder structure in Drive under the Parent Id and upload the files within accordingly

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

### -RetryCount
How many times uploads should be retried when using the -Wait parameter

Defaults to 10

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 10
Accept pipeline input: False
Accept wildcard characters: False
```

### -ThrottleLimit
The limit of files to upload per batch while waiting

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 20
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The email or unique Id of the user to upload the files for

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

### -Wait
If $true, waits for all uploads to complete and shows progress around the total upload

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

## NOTES

## RELATED LINKS
