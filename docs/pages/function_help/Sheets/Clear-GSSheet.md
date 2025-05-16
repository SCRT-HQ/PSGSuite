# Clear-GSSheet

## SYNOPSIS
Clears a Sheet

## SYNTAX

```
Clear-GSSheet [-SpreadsheetId] <String> [-SheetName <String>] [-Range <String>] [-User <String>] [-Raw]
 [<CommonParameters>]
```

## DESCRIPTION
Clears a Sheet

## EXAMPLES

### EXAMPLE 1
```
Clear-GSSheet -SpreadsheetId '1ZVdewVhy-VtVLyGL1lk2kgvySIF_bCfJA6ggn7obGh2U' -SheetName 2017
```

Clears the Sheet '2017' located on the SpreadSheet Id provided

## PARAMETERS

### -Range
The specific range to clear.
If excluded, clears the entire Sheet

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
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SheetName
The name of the Sheet (tab) to clear

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
The unique Id of the SpreadSheet

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
The primary email of the user who has Edit rights to the target Range/Sheet

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

### Google.Apis.Sheets.v4.Data.Spreadsheet
## NOTES

## RELATED LINKS
