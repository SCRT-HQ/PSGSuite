# Get-GSDriveFileUploadStatus

## SYNOPSIS
Gets the current Drive file upload status

## SYNTAX

```
Get-GSDriveFileUploadStatus [[-Id] <Int32[]>] [-InProgress] [<CommonParameters>]
```

## DESCRIPTION
Gets the current Drive file upload status

## EXAMPLES

### EXAMPLE 1
```
Get-GSDriveFileUploadStatus -InProgress
```

Gets the upload status for all tasks currently in progress

## PARAMETERS

### -Id
The upload Id for the task you'd like to retrieve the status of

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

### -InProgress
If passed, only returns upload statuses that are not 'Failed' or 'Completed'.
If nothing is returned when passing this parameter, all tracked uploads have stopped

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
