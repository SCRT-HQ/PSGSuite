# Add-GSDocContent

## SYNOPSIS
Adds content to a Google Doc via appending new text.
This does not overwrite existing content

## SYNTAX

```
Add-GSDocContent [-FileID] <String> -Value <String[]> [-User <String>] [<CommonParameters>]
```

## DESCRIPTION
Adds content to a Google Doc via appending new text.
This does not overwrite existing content

## EXAMPLES

### EXAMPLE 1
```
$newLogStrings | Add-GSDocContent -FileId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976'
```

Appends the strings in the $newLogStrings variable to the existing the content of the specified Google Doc.

## PARAMETERS

### -FileID
The unique Id of the file to add content to

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

### -Value
The content to add

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
