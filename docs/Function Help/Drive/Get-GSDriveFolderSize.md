# Get-GSDriveFolderSize

## SYNOPSIS
Gets the size of the files with the specified ParentFolderId in Drive.

## SYNTAX

```
Get-GSDriveFolderSize [-ParentFolderId] <String[]> [-Recurse] [-Depth <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Gets the size of the files with the specified ParentFolderId in Drive.

## EXAMPLES

### EXAMPLE 1
```
Get-GSDriveFolderSize -ParentFolderId $id1,$id2 -Recurse
```

## PARAMETERS

### -Depth
Internal use only.
Used to track how deep in the subfolder structure the command is currently searching when used with -Verbose

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentFolderId
ID of parent folder to search to add to the filter

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Id

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
