# Export-PSGSuiteConfig

## SYNOPSIS
Allows you to export an unecrypted PSGSuite config in a portable JSON string format.
Useful for moving a config to a new machine or storing the full as an encrypted string in your CI/CD / Automation tools.

## SYNTAX

```
Export-PSGSuiteConfig [[-Path] <String>] [-ConfigName <String>] [<CommonParameters>]
```

## DESCRIPTION
Allows you to export an unecrypted PSGSuite config in a portable JSON string format.
Useful for moving a config to a new machine or storing the full as an encrypted string in your CI/CD / Automation tools.

## EXAMPLES

### EXAMPLE 1
```
Export-PSGSuiteConfig -ConfigName Personal -Path ".\PSGSuite_personal_config.json"
```

Exports the config named 'Personal' to the path specified.

## PARAMETERS

### -ConfigName
The config that you would like to export.
Defaults to the currently loaded config.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $script:PSGSuite.ConfigName
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
The path you would like to save the JSON file to.
Defaults to a named path in the current directory.

```yaml
Type: String
Parameter Sets: (All)
Aliases: OutPath, OutFile, JsonPath

Required: False
Position: 1
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
