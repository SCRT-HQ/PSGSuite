# Import-PSGSuiteConfig

## SYNOPSIS
Allows you to import an unecrypted PSGSuite config from a portable JSON string format, typically created with Export-PSGSuiteConfig.
Useful for moving a config to a new machine or storing the full as an encrypted string in your CI/CD / Automation tools.

## SYNTAX

### Json (Default)
```
Import-PSGSuiteConfig [-Json] <String> [-Temporary] [-PassThru] [<CommonParameters>]
```

### Path
```
Import-PSGSuiteConfig -Path <String> [-Temporary] [-PassThru] [<CommonParameters>]
```

## DESCRIPTION
Allows you to import an unecrypted PSGSuite config from a portable JSON string format, typically created with Export-PSGSuiteConfig.
Useful for moving a config to a new machine or storing the full as an encrypted string in your CI/CD / Automation tools.

## EXAMPLES

### EXAMPLE 1
```
Import-Module PSGSuite -MinimumVersion 2.22.0
```

Import-PSGSuiteConfig -Json '$(PSGSuiteConfigJson)' -Temporary

Azure Pipelines inline script task that uses a Secure Variable named 'PSGSuiteConfigJson' with the Config JSON string stored in it, removing the need to include credential or key files anywhere.

## PARAMETERS

### -Json
The Json string to import.

```yaml
Type: String
Parameter Sets: Json
Aliases: J

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -PassThru
If $true, outputs the resulting config object to the pipeline.

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
The path of the Json file you would like import.

```yaml
Type: String
Parameter Sets: Path
Aliases: P

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Temporary
If $true, the imported config is not stored in the config file and the imported config persists only for the current session.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: Temp, T

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
