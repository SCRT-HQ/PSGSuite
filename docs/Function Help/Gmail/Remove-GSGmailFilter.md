# Remove-GSGmailFilter

## SYNOPSIS
Removes a Gmail filter

## SYNTAX

```
Remove-GSGmailFilter [[-User] <String>] -FilterId <String[]> [-Raw] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes a Gmail filter

## EXAMPLES

### EXAMPLE 1
```
Remove-GSGmailFilter -FilterId ANe1Bmj5l3089jd3k1eQbY90g9rXswjS03LVOw
```

Removes the Filter from the AdminEmail user after confirmation

## PARAMETERS

### -FilterId
The unique Id of the filter to remove

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Id

Required: True
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
The primary email of the user to remove the filter from

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

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
