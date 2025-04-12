# Copy-GSSheet

## SYNOPSIS
Copies a Sheet from one SpreadSheet to another

## SYNTAX

### CreateNewSheet (Default)
```
Copy-GSSheet [-SourceSpreadsheetId] <String> [-SourceSheetId] <String> [-NewSheetTitle <String>]
 [-User <String>] [-Raw] [<CommonParameters>]
```

### UseExisting
```
Copy-GSSheet [-SourceSpreadsheetId] <String> [-SourceSheetId] <String> [-DestinationSpreadsheetId] <String>
 [-User <String>] [-Raw] [<CommonParameters>]
```

## DESCRIPTION
Copies a Sheet from one SpreadSheet to another

## EXAMPLES

### EXAMPLE 1
```
Copy-GSSheet -SourceSpreadsheetId '1ZVdewVhy-VtVLyGLhClkj8234ljk_fJA6ggn7obGh2U' -SourceSheetId 2017 -NewSheetTitle '2017 Archive'
```

Copies the Sheet '2017' from the SourceSpreadsheet provided onto a new SpreadSheet named '2017 Archive'

## PARAMETERS

### -DestinationSpreadsheetId
The target SpreadSheet to copy the Sheet to

```yaml
Type: String
Parameter Sets: UseExisting
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewSheetTitle
The new title for the new SpreadhSheet to create if not copying to a Destination Sheet

```yaml
Type: String
Parameter Sets: CreateNewSheet
Aliases: SheetTitle

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

### -SourceSheetId
The Id of the Sheet to copy

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourceSpreadsheetId
The unique Id of the SpreadSheet to copy the Sheet from

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
The primary email of the user who has at least Edit rights to both the Source SpreadSheet and Destination SpreadSheet

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

## NOTES

## RELATED LINKS
