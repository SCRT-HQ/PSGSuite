# New-GSOrganizationalUnit

## SYNOPSIS
Creates a new OrgUnit

## SYNTAX

### ParentOrgUnitPath (Default)
```
New-GSOrganizationalUnit -Name <String> [-ParentOrgUnitPath <String>] [-Description <String>]
 [-BlockInheritance] [<CommonParameters>]
```

### ParentOrgUnitId
```
New-GSOrganizationalUnit -Name <String> [-ParentOrgUnitId <String>] [-Description <String>] [-BlockInheritance]
 [<CommonParameters>]
```

## DESCRIPTION
Creates a new Organizational Unit

## EXAMPLES

### EXAMPLE 1
```
New-GSOrganizationalUnit -Name "Test Org" -ParentOrgUnitPath "/Testing" -Description "This is a test OrgUnit"
```

Creates a new OrgUnit named "Test Org" underneath the existing org unit path "/Testing" with the description "This is a test OrgUnit"

## PARAMETERS

### -BlockInheritance
Determines if a sub-organizational unit can inherit the settings of the parent organization.
The default value is false, meaning a sub-organizational unit inherits the settings of the nearest parent organizational unit.
For more information on inheritance and users in an organization structure, see the administration help center: http://support.google.com/a/bin/answer.py?hl=en&answer=182442&topic=1227584&ctx=topic

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

### -Description
Description of the organizational unit.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the new OrgUnit

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentOrgUnitId
The unique ID of the parent organizational unit.

```yaml
Type: String
Parameter Sets: ParentOrgUnitId
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentOrgUnitPath
The path of the parent OrgUnit

Defaults to "/" (the root OrgUnit)

```yaml
Type: String
Parameter Sets: ParentOrgUnitPath
Aliases:

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

### Google.Apis.Admin.Directory.directory_v1.Data.OrgUnit
## NOTES

## RELATED LINKS
