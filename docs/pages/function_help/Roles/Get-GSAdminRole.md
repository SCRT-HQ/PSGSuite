# Get-GSAdminRole

## SYNOPSIS
Gets a specific Admin Role or the list of Admin Roles

## SYNTAX

### List (Default)
```
Get-GSAdminRole [-PageSize <Int32>] [-Limit <Int32>] [<CommonParameters>]
```

### Get
```
Get-GSAdminRole [-RoleId] <Int64[]> [<CommonParameters>]
```

## DESCRIPTION
Gets a specific Admin Role or the list of Admin Roles

## EXAMPLES

### EXAMPLE 1
```
Get-GSAdminRole
```

Gets the list of Admin Roles

### EXAMPLE 2
```
Get-GSAdminRole -RoleId 9191482342768644,9191482342768642
```

Gets the admin roles matching the provided Ids

## PARAMETERS

### -Limit
The maximum amount of results you want returned.
Exclude or set to 0 to return all results

```yaml
Type: Int32
Parameter Sets: List
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
Parameter Sets: List
Aliases: MaxResults

Required: False
Position: Named
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### -RoleId
The RoleId(s) you would like to retrieve info for.

If left blank, returns the full list of Roles

```yaml
Type: Int64[]
Parameter Sets: Get
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Admin.Directory.directory_v1.Data.Role
## NOTES

## RELATED LINKS
