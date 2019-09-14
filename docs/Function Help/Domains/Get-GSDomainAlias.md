# Get-GSDomainAlias

## SYNOPSIS
Retrieves a Domain Alias

## SYNTAX

### List (Default)
```
Get-GSDomainAlias [[-ParentDomainName] <String[]>] [<CommonParameters>]
```

### Get
```
Get-GSDomainAlias [[-DomainAliasName] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves a Domain Alias

## EXAMPLES

### EXAMPLE 1
```
Get-GSDDomainAlias
```

Returns the list of domain aliases for all domains.

## PARAMETERS

### -DomainAliasName
Name of the domain alias to retrieve.

If excluded, returns the list of domain aliases.

```yaml
Type: String[]
Parameter Sets: Get
Aliases: DomainAlias

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -ParentDomainName
Name of the parent domain to list aliases for.

If excluded, lists all aliases for all domains.

```yaml
Type: String[]
Parameter Sets: List
Aliases:

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

### Google.Apis.Admin.Directory.directory_v1.Data.DomainAlias
## NOTES

## RELATED LINKS
