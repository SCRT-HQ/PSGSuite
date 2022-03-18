# Get-GSDocContent

## SYNOPSIS
Gets the content of a Google Doc and returns it as an array of strings.
Supports HTML or PlainText

## SYNTAX

```
Get-GSDocContent [-FileID] <String> [-User <String>] [-Type <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets the content of a Google Doc and returns it as an array of strings.
Supports HTML or PlainText

## EXAMPLES

### EXAMPLE 1
```
Get-GSDocContent -FileId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976'
```

Exports the Drive file as a CSV to the current working directory

## PARAMETERS

### -FileID
The unique Id of the file to get content of

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

### -Type
Whether to get the results in HTML or PlainText format.

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
The email or unique Id of the owner of the Drive file

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
