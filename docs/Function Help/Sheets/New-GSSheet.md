# New-GSSheet

## SYNOPSIS
Creates a new SpreadSheet

## SYNTAX

```
New-GSSheet [[-Title] <String>] [[-User] <String>] [-Launch] [<CommonParameters>]
```

## DESCRIPTION
Creates a new SpreadSheet

## EXAMPLES

### EXAMPLE 1
```
New-GSSheet -Title "Finance Workbook" -Launch
```

Creates a new SpreadSheet titled "Finance Workbook" and opens it in the browser on creation

## PARAMETERS

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

### -Title
The name of the new SpreadSheet

```yaml
Type: String
Parameter Sets: (All)
Aliases: SheetTitle

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The user to create the Sheet for

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
