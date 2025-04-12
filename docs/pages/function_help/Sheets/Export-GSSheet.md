# Export-GSSheet

## SYNOPSIS
Updates a Sheet's values

## SYNTAX

### CreateNewSheetArray (Default)
```
Export-GSSheet [[-NewSheetTitle] <String>] [-Array] <Object[]> [-SheetName <String>] [-Style <String>]
 [-Range <String>] [-Append] [-User <String>] [-ValueInputOption <String>] [-IncludeValuesInResponse] [-Launch]
 [<CommonParameters>]
```

### UseExistingValue
```
Export-GSSheet [-SpreadsheetId] <String> [-Value] <String> [-SheetName <String>] [-Range <String>] [-Append]
 [-User <String>] [-ValueInputOption <String>] [-IncludeValuesInResponse] [-Launch] [<CommonParameters>]
```

### UseExistingArray
```
Export-GSSheet [-SpreadsheetId] <String> [-Array] <Object[]> [-SheetName <String>] [-Style <String>]
 [-Range <String>] [-Append] [-User <String>] [-ValueInputOption <String>] [-IncludeValuesInResponse] [-Launch]
 [<CommonParameters>]
```

### CreateNewSheetValue
```
Export-GSSheet [[-NewSheetTitle] <String>] [-Value] <String> [-SheetName <String>] [-Range <String>] [-Append]
 [-User <String>] [-ValueInputOption <String>] [-IncludeValuesInResponse] [-Launch] [<CommonParameters>]
```

## DESCRIPTION
Updates a Sheet's values.
Accepts either an Array of objects/strings/ints or a single value

## EXAMPLES

### EXAMPLE 1
```
$array | Export-GSSheet -NewSheetTitle "Finance Workbook" -Launch
```

## PARAMETERS

### -Append
If $true, skips adding headers to the Sheet

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

### -Array
Array of objects/strings/ints to add to the SpreadSheet

```yaml
Type: Object[]
Parameter Sets: CreateNewSheetArray, UseExistingArray
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -IncludeValuesInResponse
Determines if the update response should include the values of the cells that were updated.
By default, responses do not include the updated values

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

### -Launch
If $true, opens the new SpreadSheet Url in your default browser

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: Open

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewSheetTitle
The title of the new SpreadSheet to be created

```yaml
Type: String
Parameter Sets: CreateNewSheetArray, CreateNewSheetValue
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Range
The specific range to add the value(s) to.
If using the -Value parameter, set this to the specific cell you would like to set the value of

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

### -SheetName
The name of the Sheet to add the data to.
If excluded, defaults to Sheet Id '0'.
If a new SpreadSheet is being created, this is set to 'Sheet1' to prevent error

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
The unique Id of the SpreadSheet to update if updating an existing Sheet

```yaml
Type: String
Parameter Sets: UseExistingValue, UseExistingArray
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Style
The table style you would like to export the data as

Available values are:
* "Standard": headers are on Row 1, table rows are added as subsequent rows (Default)
* "Horizontal": headers are on Column A, table rows are added as subsequent columns

```yaml
Type: String
Parameter Sets: CreateNewSheetArray, UseExistingArray
Aliases:

Required: False
Position: Named
Default value: Standard
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The primary email of the user that had at least Edit rights to the target Sheet

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

### -Value
A single value to update 1 cell with.
Useful if you are tracking the last time updated in a specific cell during a job that updates Sheets

```yaml
Type: String
Parameter Sets: UseExistingValue, CreateNewSheetValue
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ValueInputOption
How the input data should be interpreted

Available values are:
* "INPUT_VALUE_OPTION_UNSPECIFIED"
* "RAW"
* "USER_ENTERED"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: RAW
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Sheets.v4.Data.Spreadsheet
## NOTES

## RELATED LINKS
