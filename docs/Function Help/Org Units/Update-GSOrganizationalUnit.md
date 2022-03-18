# Update-GSOrganizationalUnit

## SYNOPSIS
Updates an OrgUnit

## SYNTAX

### Id (Default)
```
Update-GSOrganizationalUnit [-OrgUnitID] <String> [-Name <String>] [-ParentOrgUnitId <String>]
 [-ParentOrgUnitPath <String>] [-Description <String>] [-BlockInheritance] [<CommonParameters>]
```

### Path
```
Update-GSOrganizationalUnit [-OrgUnitPath] <String> [-Name <String>] [-ParentOrgUnitId <String>]
 [-ParentOrgUnitPath <String>] [-Description <String>] [-BlockInheritance] [<CommonParameters>]
```

## DESCRIPTION
Updates an Organizational Unit

## EXAMPLES

### EXAMPLE 1
```
Update-GSOrganizationalUnit -OrgUnitPath "/Testing" -Name "Testing More" -Description "Doing some more testing"
```

Updates the OrgUnit '/Testing' with a new name "Testing More" and new description "Doing some more testing"

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
The new description for the OrgUnit

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
The new name for the OrgUnit

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

### -OrgUnitID
The unique Id of the OrgUnit to update

```yaml
Type: String
Parameter Sets: Id
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -OrgUnitPath
The path of the OrgUnit to update

```yaml
Type: String
Parameter Sets: Path
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ParentOrgUnitId
The new Parent ID for the OrgUnit

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

### -ParentOrgUnitPath
The path of the new Parent for the OrgUnit

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Admin.Directory.directory_v1.Data.OrgUnit
## NOTES

## RELATED LINKS
