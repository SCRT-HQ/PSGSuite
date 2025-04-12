# Set-GSDocContent

## SYNOPSIS
Sets the content of a Google Doc.
This overwrites any existing content on the Doc

## SYNTAX

```
Set-GSDocContent [-FileID] <String> -Value <String[]> [-User <String>] [<CommonParameters>]
```

## DESCRIPTION
Sets the content of a Google Doc.
This overwrites any existing content on the Doc

## EXAMPLES

### EXAMPLE 1
```
$logStrings | Set-GSDocContent -FileId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976'
```

Sets the content of the specified Google Doc to the strings in the $logStrings variable.
Any existing content on the doc will be overwritten.

## PARAMETERS

### -FileID
The unique Id of the file to set content on

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
The content to set

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
