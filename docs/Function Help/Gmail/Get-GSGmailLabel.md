# Get-GSGmailLabel

## SYNOPSIS
Gets Gmail label information for the user

## SYNTAX

```
Get-GSGmailLabel [-LabelId <String[]>] [[-User] <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets Gmail label information for the user

## EXAMPLES

### EXAMPLE 1
```
Get-GSGmailLabel
```

Gets the Gmail labels of the AdminEmail user

## PARAMETERS

### -LabelId
The unique Id of the label to get information for.
If excluded, returns the list of labels for the user

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Id

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -User
The user to get label information for

Defaults to the AdminEmail user

```yaml
Type: String
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail

Required: False
Position: 1
Default value: $Script:PSGSuite.AdminEmail
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Gmail.v1.Data.Label
## NOTES

## RELATED LINKS
