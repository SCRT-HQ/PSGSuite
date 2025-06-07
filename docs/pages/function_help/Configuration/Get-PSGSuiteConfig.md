# Get-PSGSuiteConfig

## SYNOPSIS
Loads the specified PSGSuite config

## SYNTAX

### ConfigurationModule (Default)
```
Get-PSGSuiteConfig [[-ConfigName] <String>] [[-Scope] <String>] [-PassThru] [-NoImport] [<CommonParameters>]
```

### Path
```
Get-PSGSuiteConfig [-Path <String>] [[-Scope] <String>] [-PassThru] [-NoImport] [<CommonParameters>]
```

## DESCRIPTION
Loads the specified PSGSuite config

## EXAMPLES

### EXAMPLE 1
```
Get-PSGSuiteConfig personalDomain -PassThru
```

This will load the config named "personalDomain" and return it as a PSObject.

## PARAMETERS

### -ConfigName
The config name to load

```yaml
Type: String
Parameter Sets: ConfigurationModule
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoImport
If $true, just returns the specified config but does not impart it in the current session.

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

### -PassThru
If specified, returns the config after loading it

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

### -Path
The path of the config to load if non-default.

This can be used to load either a legacy XML config from an older version of PSGSuite or a specific .PSD1 config created with version 2.0.0 or greater

```yaml
Type: String
Parameter Sets: Path
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Scope
The config scope to load

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $Script:ConfigScope
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
