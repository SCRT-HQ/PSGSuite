# Import-GSSheet

## SYNOPSIS
Imports data from a Sheet as if it was a CSV

## SYNTAX

### Import (Default)
```
Import-GSSheet -SpreadsheetId <String> [-SheetName <String>] [-User <String>] [-Range <String>]
 [-RowStart <Int32>] [-Headers <String[]>] [-DateTimeRenderOption <String>] [-ValueRenderOption <String>]
 [-MajorDimension <String>] [-As <String>] [<CommonParameters>]
```

### Raw
```
Import-GSSheet -SpreadsheetId <String> [-SheetName <String>] [-User <String>] [-Range <String>]
 [-DateTimeRenderOption <String>] [-ValueRenderOption <String>] [-MajorDimension <String>] [-Raw]
 [<CommonParameters>]
```

## DESCRIPTION
Imports data from a Sheet as if it was a CSV

## EXAMPLES

### EXAMPLE 1
```
Import-GSSheet -SpreadsheetId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976' -SheetName Sheet1 -RowStart 2 -Range 'B:C'
```

Imports columns B-C as an Array of PSObjects, skipping the first row and treating Row 2 as the header row.
Objects in the array will be what's contained in range 'B3:C' after that

## PARAMETERS

### -As
Whether to return the result set as an array of PSObjects or an array of DataRows

Available values are:
* "PSObject" (Default)
* "DataRow"

```yaml
Type: String
Parameter Sets: Import
Aliases:

Required: False
Position: Named
Default value: PSObject
Accept pipeline input: False
Accept wildcard characters: False
```

### -DateTimeRenderOption
How to render the DateTime cells

Available values are:
* "FORMATTED_STRING" (Default)
* "SERIAL_NUMBER"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: FORMATTED_STRING
Accept pipeline input: False
Accept wildcard characters: False
```

### -Headers
Allows you to define the headers for the rows on the sheet, in case there is no header row

```yaml
Type: String[]
Parameter Sets: Import
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MajorDimension
The major dimension that results should use.

For example, if the spreadsheet data is: A1=1,B1=2,A2=3,B2=4, then requesting range=A1:B2,majorDimension=ROWS will return \[\[1,2\],\[3,4\]\], whereas requesting range=A1:B2,majorDimension=COLUMNS will return \[\[1,3\],\[2,4\]\].

Available values are:
* "ROWS" (Default)
* "COLUMNS"
* "DIMENSION_UNSPECIFIED"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: ROWS
Accept pipeline input: False
Accept wildcard characters: False
```

### -Range
The specific range to import data from

```yaml
Type: String
Parameter Sets: (All)
Aliases: SpecifyRange

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Raw
If $true, return the raw response, otherwise, return a flattened response for readability

```yaml
Type: SwitchParameter
Parameter Sets: Raw
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -RowStart
The starting row of data.
Useful if the headers for your table are not in Row 1 of the Sheet

```yaml
Type: Int32
Parameter Sets: Import
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -SheetName
The name of the Sheet to import data from

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

### -SpreadsheetId
The unique Id of the SpreadSheet to import data from

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
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
Position: Named
Default value: $Script:PSGSuite.AdminEmail
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ValueRenderOption
How to render the value cells and formula cells

Available values are:
* "FORMATTED_VALUE" (Default)
* "UNFORMATTED_VALUE"
* "FORMULA"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: FORMATTED_VALUE
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
