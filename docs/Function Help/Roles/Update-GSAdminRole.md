# Update-GSAdminRole

## SYNOPSIS
Update an Admin Role

## SYNTAX

```
Update-GSAdminRole [-RoleId] <Int64> [-RoleName <String>] [-RolePrivileges <RolePrivilegesData[]>]
 [-RoleDescription <String>] [<CommonParameters>]
```

## DESCRIPTION
Update an Admin Role

## EXAMPLES

### EXAMPLE 1
```
Update-GSAdminRole -RoleId 9191482342768644 -RoleName 'Help_Desk_Level2' -RoleDescription 'Help Desk Level 2'
```

Updates the specified Admin Role with a new name and description

### EXAMPLE 2
```
Get-GSAdminRole | Where-Object {$_.RoleDescription -like "*Help*Desk*"} | Update-GSAdminRole -RoleId 9191482342768644 -RoleName 'Help_Desk_Level2' -RoleDescription 'Help Desk Level 2'
```

Updates the specified Admin Role's RolePrivileges to match every other Admin Role with Help Desk in the description.
Useful for basing a new role off another to add additional permissions on there

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

### -RoleId
The Id of the role to update

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -RoleName
The name of the role

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

### -RolePrivileges
The set of privileges that are granted to this role.

```yaml
Type: RolePrivilegesData[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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
