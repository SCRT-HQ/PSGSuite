# Remove-GSDriveRevision

## SYNOPSIS
Permanently deletes a file version.

## SYNTAX

```
Remove-GSDriveRevision [-FileId] <String> [-RevisionId] <String[]> [-User <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Permanently deletes a file version.

You can only delete revisions for files with binary content in Google Drive, like images or videos.
Revisions for other files, like Google Docs or Sheets, and the last remaining file version can't be deleted.

## EXAMPLES

### EXAMPLE 1
```
Get-GSDriveRevision -FileId $fileId -Limit 1 | Remove-GSDriveRevision
```

Removes the oldest revision for the file

### EXAMPLE 2
```
Get-GSDriveRevision -FileId $fileId | Select-Object -Last 1 | Remove-GSDriveRevision
```

Removes the newest revision for the file

## PARAMETERS

### -FileId
The unique Id of the file to remove revisions from

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -RevisionId
The unique Id of the revision to remove

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Id

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
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

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

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
