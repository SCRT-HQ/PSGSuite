# Remove-GSUserLicense

## SYNOPSIS
Removes a license assignment from a user

## SYNTAX

```
Remove-GSUserLicense [-User] <String[]> [-License] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes a license assignment from a user.
Useful for restoring a user from a Vault-Former-Employee to an auto-assigned G Suite Business license by removing the Vault-Former-Employee license, for example.

## EXAMPLES

### EXAMPLE 1
```
Remove-GSUserLicense -User joe -License Google-Vault-Former-Employee
```

Removes the Vault-Former-Employee license from Joe

## PARAMETERS

### -License
The license SKU to remove from the user

```yaml
Type: String
Parameter Sets: (All)
Aliases: SkuId

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The user's current primary email address

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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
