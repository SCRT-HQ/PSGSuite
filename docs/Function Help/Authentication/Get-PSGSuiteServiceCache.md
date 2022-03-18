# Get-PSGSuiteServiceCache

## SYNOPSIS
Returns the dictionary of cached service objects created with New-GoogleService for inspection.

## SYNTAX

```
Get-PSGSuiteServiceCache [-IncludeKeys] [<CommonParameters>]
```

## DESCRIPTION
Returns the dictionary of cached service objects created with New-GoogleService for inspection.

The keys in the session cache dictionary are comprised of the following values which are added to the cache whenever a new session is created:

    $SessionKey = @($User,$ServiceType,$(($Scope | Sort-Object) -join ";")) -join ";"

## EXAMPLES

### EXAMPLE 1
```
Get-PSGSuiteServiceCache
```

## PARAMETERS

### -IncludeKeys
If $true, returns the full service cache dictionary including keys.

Defaults to $false.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
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

[https://psgsuite.io/Function%20Help/Authentication/Get-PSGSuiteServiceCache/](https://psgsuite.io/Function%20Help/Authentication/Get-PSGSuiteServiceCache/)

