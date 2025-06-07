# Get-GSAdminRoleAssignment

## SYNOPSIS
Gets a specific Admin Role Assignments or the list of Admin Role Assignments for a given role

## SYNTAX

### ListUserKey (Default)
```
Get-GSAdminRoleAssignment [-UserKey <String[]>] [-PageSize <Int32>] [-Limit <Int32>] [<CommonParameters>]
```

### Get
```
Get-GSAdminRoleAssignment [-RoleAssignmentId] <String[]> [<CommonParameters>]
```

### ListRoleId
```
Get-GSAdminRoleAssignment [-RoleId <String[]>] [-PageSize <Int32>] [-Limit <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Gets a specific Admin Role Assignments or the list of Admin Role Assignments for a given role

## EXAMPLES

### EXAMPLE 1
```
Get-GSAdminRoleAssignment
```

Gets the list of Admin Role Assignments

### EXAMPLE 2
```
Get-GSAdminRoleAssignment -RoleId 9191482342768644,9191482342768642
```

Gets the Admin Role Assignments matching the provided RoleIds

## PARAMETERS

### -Limit
The maximum amount of results you want returned.
Exclude or set to 0 to return all results

```yaml
Type: Int32
Parameter Sets: ListUserKey, ListRoleId
Aliases: First

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
Page size of the result set

```yaml
Type: Int32
Parameter Sets: ListUserKey, ListRoleId
Aliases: MaxResults

Required: False
Position: Named
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### -RoleAssignmentId
The RoleAssignmentId(s) you would like to retrieve info for.

If left blank, returns the full list of Role Assignments

```yaml
Type: String[]
Parameter Sets: Get
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RoleId
The RoleId(s) you would like to retrieve Role Assignments for.

If left blank, returns the full list of Role Assignments

```yaml
Type: String[]
Parameter Sets: ListRoleId
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserKey
The UserKey(s) you would like to retrieve Role Assignments for.
This can be a user's email or their unique UserId

If left blank, returns the full list of Role Assignments

```yaml
Type: String[]
Parameter Sets: ListUserKey
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

### Google.Apis.Admin.Directory.directory_v1.Data.RoleAssignment
## NOTES

## RELATED LINKS
