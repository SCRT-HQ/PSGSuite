# Get-GSDomain

## SYNOPSIS
Retrieves a Domain

## SYNTAX

```
Get-GSDomain [[-DomainName] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves a Domain

## EXAMPLES

### EXAMPLE 1
```
Get-GSDDomain
```

Returns the list of domains.

## PARAMETERS

### -DomainName
Name of the domain to retrieve.

If excluded, returns the list of domains.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Domain

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Admin.Directory.directory_v1.Data.Domains
## NOTES

## RELATED LINKS
