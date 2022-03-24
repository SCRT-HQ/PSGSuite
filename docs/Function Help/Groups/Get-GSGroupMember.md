# Get-GSGroupMember

## SYNOPSIS
Gets the group member list of a target group

## SYNTAX

### List (Default)
```
Get-GSGroupMember [-Identity] <String[]> [-Roles <String[]>] [-PageSize <Int32>] [-Limit <Int32>]
 [<CommonParameters>]
```

### Get
```
Get-GSGroupMember [-Identity] <String[]> [[-Member] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Gets the group member list of a target group.
Designed for parity with Get-ADGroupMember

## EXAMPLES

### EXAMPLE 1
```
Get-GSGroupMember "admins@domain.com" -Roles Owner,Manager
```

Returns the list of owners and managers of the group "admins@domain.com"

## PARAMETERS

### -Identity
The email or GroupID of the target group

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: GroupEmail, Group, Email

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

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

### -Member
If specified, returns only the information for this member of the target group

```yaml
Type: String[]
Parameter Sets: Get
Aliases: PrimaryEmail, UserKey, Mail, User, UserEmail, Members

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
Page size of the result set

```yaml
Type: Int32
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: 200
Accept pipeline input: False
Accept wildcard characters: False
```

### -Roles
If specified, returns only the members of the specified role(s)

```yaml
Type: String[]
Parameter Sets: List
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

### Google.Apis.Admin.Directory.directory_v1.Data.Member
## NOTES

## RELATED LINKS
