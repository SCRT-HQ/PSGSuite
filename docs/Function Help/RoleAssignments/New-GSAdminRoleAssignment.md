# New-GSAdminRoleAssignment

## SYNOPSIS
Creates a new Admin Role Assignment

## SYNTAX

```
New-GSAdminRoleAssignment [-AssignedTo] <String[]> -RoleId <Int64> [-OrgUnitId <String>] [-ScopeType <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Creates a new Admin Role Assignment

## EXAMPLES

### EXAMPLE 1
```
New-GSAdminRoleAssignment -AssignedTo jsmith -RoleId 9191482342768644
```

Assign a new role to a given user.

## PARAMETERS

### -AssignedTo
The unique ID of the user this role is assigned to.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OrgUnitId
If the role is restricted to an organization unit, this contains the ID for the organization unit the exercise of this role is restricted to.

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

### -RoleId
The ID of the role that is assigned.

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScopeType
The scope in which this role is assigned.

Acceptable values are:
* "CUSTOMER"
* "ORG_UNIT"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: CUSTOMER
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Admin.Directory.directory_v1.Data.RoleAssignment
## NOTES

## RELATED LINKS
