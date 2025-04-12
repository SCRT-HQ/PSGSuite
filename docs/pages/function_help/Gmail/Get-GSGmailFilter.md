# Get-GSGmailFilter

## SYNOPSIS
Gets Gmail filter details

## SYNTAX

```
Get-GSGmailFilter [-FilterId <String[]>] [[-User] <String>] [-Raw] [<CommonParameters>]
```

## DESCRIPTION
Gets Gmail filter details

## EXAMPLES

### EXAMPLE 1
```
Get-GSGmailFilter -User joe
```

Gets the list of filters for Joe

## PARAMETERS

### -FilterId
The unique Id of the filter you would like to retrieve information for.
If excluded, all filters for the user are returned

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

### -Raw
If $true, returns the raw response.
If not passed or -Raw:$false, response is formatted as a flat object for readability

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

### -User
The email of the user you are getting the filter information for

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

### Google.Apis.Gmail.v1.Data.Filter
## NOTES

## RELATED LINKS
