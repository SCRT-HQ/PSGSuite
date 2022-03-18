# New-GSDomainAlias

## SYNOPSIS
Adds a new Domain Alias

## SYNTAX

```
New-GSDomainAlias [-DomainAliasName] <String> [-ParentDomainName] <String> [<CommonParameters>]
```

## DESCRIPTION
Adds a new Domain Alias

## EXAMPLES

### EXAMPLE 1
```
New-GSDDomainAlias -DomainAliasName 'testingalias.com' -ParentDomainName 'testing.com'
```

Adds a new domain alias named 'testingalias.com' to parent domain 'testing.com'

## PARAMETERS

### -DomainAliasName
Name of the domain alias to add.

```yaml
Type: String
Parameter Sets: (All)
Aliases: DomainAlias

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -ParentDomainName
Name of the parent domain to add the alias for.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
