# New-GSAdminRole

## SYNOPSIS
Creates a new Admin Role

## SYNTAX

```
New-GSAdminRole [-RoleName] <String> [-RolePrivileges] <RolePrivilegesData[]> [-RoleDescription <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Creates a new Admin Role

## EXAMPLES

### EXAMPLE 1
```
Get-GSAdminRole
```

Gets the list of Admin Roles

### EXAMPLE 2
```
Get-GSAdminRole -RoleId '9191482342768644','9191482342768642'
```

Gets the admin roles matching the provided Ids

## PARAMETERS

### -RoleDescription
A short description of the role.

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

### -RoleName
The name of the new role

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RolePrivileges
The set of privileges that are granted to this role.

```yaml
Type: RolePrivilegesData[]
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

### Google.Apis.Admin.Directory.directory_v1.Data.Role
## NOTES

## RELATED LINKS
