# Get-GSSheetInfo

## SYNOPSIS
Gets metadata about a SpreadSheet

## SYNTAX

```
Get-GSSheetInfo [-SpreadsheetId] <String> [[-User] <String>] [[-SheetName] <String>] [[-Range] <String>]
 [-IncludeGridData] [[-Fields] <String[]>] [-Raw] [<CommonParameters>]
```

## DESCRIPTION
Gets metadata about a SpreadSheet

## EXAMPLES

### EXAMPLE 1
```
Get-GSSheetInfo -SpreadsheetId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976'
```

Gets the info for the SpreadSheet provided

## PARAMETERS

### -Fields
The fields to return in the response

Available values are:
* "namedRanges"
* "properties"
* "sheets"
* "spreadsheetId"

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeGridData
Whether or not to include Grid Data in the response

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

### -Range
The specific range of the Sheet to retrieve info for

```yaml
Type: String
Parameter Sets: (All)
Aliases: SpecifyRange

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Raw
If $true, return the raw response, otherwise, return a flattened response for readability

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

### -SheetName
The name of the Sheet to retrieve info for

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SpreadsheetId
The unique Id of the SpreadSheet to retrieve info for

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The owner of the SpreadSheet

```yaml
Type: String
Parameter Sets: (All)
Aliases: Owner, PrimaryEmail, UserKey, Mail

Required: False
Position: 2
Default value: $Script:PSGSuite.AdminEmail
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Sheets.v4.Data.Spreadsheet
## NOTES

## RELATED LINKS
