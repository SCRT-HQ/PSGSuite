# Update-GSDriveRevision

## SYNOPSIS
Updates a revision with patch semantics

## SYNTAX

```
Update-GSDriveRevision [-FileId] <String> [-RevisionId] <String[]> [-KeepForever] [-PublishAuto] [-Published]
 [-PublishedOutsideDomain] [-Fields <String[]>] [-User <String>] [<CommonParameters>]
```

## DESCRIPTION
Updates a revision with patch semantics

## EXAMPLES

### EXAMPLE 1
```
Get-GSDriveRevision -FileId $fileId -Limit 1 | Update-GSDriveRevision -KeepForever
```

Sets 'KeepForever' for the oldest revision of the file to 'True'

### EXAMPLE 2
```
Get-GSDriveRevision -FileId $fileId | Select-Object -Last 1 | Update-GSDriveRevision -KeepForever
```

Sets 'KeepForever' for the newest revision of the file to 'True'

## PARAMETERS

### -Fields
The specific fields to returned

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileId
The unique Id of the file to update revisions for

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

### -KeepForever
Whether to keep this revision forever, even if it is no longer the head revision.
If not set, the revision will be automatically purged 30 days after newer content is uploaded.
This can be set on a maximum of 200 revisions for a file.

This field is only applicable to files with binary content in Drive.

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

### -PublishAuto
Whether subsequent revisions will be automatically republished.
This is only applicable to Google Docs.

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

### -Published
Whether this revision is published.
This is only applicable to Google Docs.

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

### -PublishedOutsideDomain
Whether this revision is published outside the domain.
This is only applicable to Google Docs.

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

### -RevisionId
The unique Id of the revision to update

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Drive.v3.Data.Revision
## NOTES

## RELATED LINKS
