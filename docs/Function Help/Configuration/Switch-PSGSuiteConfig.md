# Switch-PSGSuiteConfig

## SYNOPSIS
Switches the active config

## SYNTAX

### ConfigName (Default)
```
Switch-PSGSuiteConfig [-SetToDefault] -ConfigName <String> [<CommonParameters>]
```

### Domain
```
Switch-PSGSuiteConfig -Domain <String> [-SetToDefault] [<CommonParameters>]
```

## DESCRIPTION
Switches the active config

## EXAMPLES

### EXAMPLE 1
```
Switch-PSGSuiteConfig newCustomer
```

Switches the config to the "newCustomer" config

## PARAMETERS

### -ConfigName
{{ Fill ConfigName Description }}

```yaml
Type: String
Parameter Sets: ConfigName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Domain
The domain name for the config you would like to set as active for the session

```yaml
Type: String
Parameter Sets: Domain
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SetToDefault
If passed, also sets the specified config as the default so it's loaded on the next module import

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
