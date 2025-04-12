# Watch-GSDriveUpload

## SYNOPSIS
Shows progress in the console of current Drive file uploads

## SYNTAX

```
Watch-GSDriveUpload [[-Id] <Int32[]>] [-Action <String>] [-CountUploaded <Int32>] [-TotalUploading <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
Shows progress in the console of current Drive file uploads

## EXAMPLES

### EXAMPLE 1
```
Watch-GSDriveUpload
```

Watches the files currently being uploaded from the active session

## PARAMETERS

### -Action
Whether the action is uploading or retrying.
This is mainly for use in Start-GSDriveFileUpload and defaults to 'Uploading'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Uploading
Accept pipeline input: False
Accept wildcard characters: False
```

### -CountUploaded
Current file count being uploaded

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

### -Id
The upload Id(s) that you would like to watch

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -TotalUploading
Total file count being uploaded

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
