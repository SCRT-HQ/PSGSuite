# Get-GSDriveRevision

## SYNOPSIS
Gets information about a Drive file's revisions

## SYNTAX

### List (Default)
```
Get-GSDriveRevision [-FileId] <String> [-User <String>] [-Fields <String[]>] [-PageSize <Int32>]
 [-Limit <Int32>] [<CommonParameters>]
```

### Get
```
Get-GSDriveRevision [-FileId] <String> [[-RevisionId] <String[]>] [-OutFilePath <String>] [-User <String>]
 [-Fields <String[]>] [-Force] [<CommonParameters>]
```

## DESCRIPTION
Gets information about a Drive file's revisions

## EXAMPLES

### EXAMPLE 1
```
Get-GSDriveFile -FileId $fileId | Get-GSDriveRevision
```

Gets the list of revisions for the file

### EXAMPLE 2
```
Get-GSDriveRevision -FileId $fileId -Limit 1
```

Gets the most recent revision for the file

## PARAMETERS

### -Fields
The specific fields to be returned

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
The unique Id of the file to get revisions of

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

### -Force
If $true, overwrites any existing files at the desired path

```yaml
Type: SwitchParameter
Parameter Sets: Get
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
The maximum amount of objects to return

```yaml
Type: Int32
Parameter Sets: List
Aliases: First

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutFilePath
The path to save the revision to

```yaml
Type: String
Parameter Sets: Get
Aliases: SaveFileTo

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
The maximum size of each page to return

```yaml
Type: Int32
Parameter Sets: List
Aliases: MaxResults

Required: False
Position: Named
Default value: 1000
Accept pipeline input: False
Accept wildcard characters: False
```

### -RevisionId
The unique Id of the revision to get.
If excluded, gets the list of revisions for the file

```yaml
Type: String[]
Parameter Sets: Get
Aliases:

Required: False
Position: 2
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

### Google.Apis.Drive.v3.Data.Revision
## NOTES

## RELATED LINKS
