# Get-GSOrganizationalUnit

## SYNOPSIS
Gets Organizational Unit information

## SYNTAX

```
Get-GSOrganizationalUnit [[-SearchBase] <String>] [-SearchScope <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets Organizational Unit information

## EXAMPLES

### EXAMPLE 1
```
Get-GSOrganizationalUnit -SearchBase "/" -SearchScope Base
```

Gets the top level Organizational Unit information

## PARAMETERS

### -SearchBase
The OrgUnitPath you would like to search for.
This can be the single OrgUnit to return or the top level of which to return children of

```yaml
Type: String
Parameter Sets: (All)
Aliases: OrgUnitPath, BaseOrgUnitPath

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SearchScope
The depth at which to return the list of OrgUnits children

Available values are:
* "Base": only return the OrgUnit specified in the SearchBase
* "Subtree": return the full list of OrgUnits underneath the specified SearchBase
* "OneLevel": return the SearchBase and the OrgUnit's directly underneath it
* "All": same as Subtree
* "Children": same as OneLevel

Defaults to 'All'

```yaml
Type: String
Parameter Sets: (All)
Aliases: Type

Required: False
Position: Named
Default value: All
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Admin.Directory.directory_v1.Data.OrgUnit
## NOTES

## RELATED LINKS
