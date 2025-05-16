# Get-GSDriveFileList

## SYNOPSIS
Gets the list of Drive files owned by the user

## SYNTAX

```
Get-GSDriveFileList [[-User] <String>] [-Filter <String[]>] [-TeamDriveId <String>] [-ParentFolderId <String>]
 [-Recurse] [-IncludeTeamDriveItems] [-Fields <String[]>] [-Corpora <String>] [-Spaces <String[]>]
 [-OrderBy <String[]>] [-PageSize <Int32>] [-Limit <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Gets the list of Drive files owned by the user

## EXAMPLES

### EXAMPLE 1
```
Get-GSDriveFileList joe
```

Gets Joe's Drive file list

## PARAMETERS

### -Corpora
Comma-separated list of bodies of items (files/documents) to which the query applies.
Supported bodies are 'User', 'Domain', 'TeamDrive' and 'AllTeamDrives'.
'AllTeamDrives' must be combined with 'User'; all other values must be used in isolation.
Prefer 'User' or 'TeamDrive' to 'AllTeamDrives' for efficiency.

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
The specific fields to fetch for the listed files.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: @('files','kind','nextPageToken')
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
A query for filtering the file results.
See the "Search for Files and Team Drives" guide for the supported syntax: https://developers.google.com/drive/v3/web/search-parameters

PowerShell filter syntax here is supported as "best effort".
Please use Google's filter operators and syntax to ensure best results

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Q, Query

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeTeamDriveItems
Whether Team Drive items should be included in results.
(Default: false)

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

### -Limit
The maximum amount of results you want returned.
Exclude or set to 0 to return all results

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: First

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -OrderBy
A comma-separated list of sort keys.
Valid keys are 'createdTime', 'folder', 'modifiedByMeTime', 'modifiedTime', 'name', 'name_natural', 'quotaBytesUsed', 'recency', 'sharedWithMeTime', 'starred', and 'viewedByMeTime'.

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

### -PageSize
The page size of the result set

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: MaxResults

Required: False
Position: Named
Default value: 1000
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentFolderId
ID of parent folder to search to add to the filter

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

### -Recurse
If True, recurses through subfolders found underneath primary search results

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

### -Spaces
A comma-separated list of spaces to query within the corpus.
Supported values are 'Drive', 'AppDataFolder' and 'Photos'.

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

### -TeamDriveId
ID of Team Drive to search

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
The email or unique Id of the user whose Drive files you are trying to list

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

### Google.Apis.Drive.v3.Data.File
## NOTES

## RELATED LINKS
