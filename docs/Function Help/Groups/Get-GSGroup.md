# Get-GSGroup

## SYNOPSIS
Gets the specified group's information.
Returns the full group list if -Group is excluded

## SYNTAX

### ListFilter (Default)
```
Get-GSGroup [-Filter <String>] [-Domain <String>] [-PageSize <Int32>] [-Limit <Int32>] [<CommonParameters>]
```

### Get
```
Get-GSGroup [-Group] <String[]> [-Fields <String[]>] [<CommonParameters>]
```

### ListWhereMember
```
Get-GSGroup [-Where_IsAMember <String>] [-PageSize <Int32>] [-Limit <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Gets the specified group's information.
Returns the full group list if -Group is excluded.
Designed for parity with Get-ADGroup (although Google's API is unable to 'Filter' for groups)

## EXAMPLES

### EXAMPLE 1
```
Get-GSGroup -Where_IsAMember "joe@domain.com"
```

Gets the list of groups that joe@domain.com is a member of

### EXAMPLE 2
```
Get-GSGroup -Domain mysubdomain.org
```

Gets the list of groups only for the 'mysubdomain.org' domain.

### EXAMPLE 3
```
Get-GSGroup -Filter "email:support*"
```

Gets all the groups with emails beginning with 'support'

### EXAMPLE 4
```
Get-GSGroup -Filter "name -eq 'IT HelpDesk'"
```

Gets the IT HelpDesk group by name using PowerShell syntax.
PowerShell syntax is supported as a best effort, please refer to the Group Search documentation from Google for exact syntax.

## PARAMETERS

### -Domain
The domain name.
Use this field to get fields from only one domain.
To return groups for all domains you own, exclude this parameter

```yaml
Type: String
Parameter Sets: ListFilter
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fields
The fields to return in the response

```yaml
Type: String[]
Parameter Sets: Get
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
Query string search.
Complete documentation is at https://developers.google.com/admin-sdk/directory/v1/guides/search-groups

```yaml
Type: String
Parameter Sets: ListFilter
Aliases: Query

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Group
The list of groups you would like to retrieve info for.
If excluded, returns the group list instead

```yaml
Type: String[]
Parameter Sets: Get
Aliases: Email

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
Parameter Sets: ListFilter, ListWhereMember
Aliases: First

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
Page size of the result set

Defaults to 200

```yaml
Type: Int32
Parameter Sets: ListFilter, ListWhereMember
Aliases: MaxResults

Required: False
Position: Named
Default value: 200
Accept pipeline input: False
Accept wildcard characters: False
```

### -Where_IsAMember
Include a user email here to get the list of groups that user is a member of

```yaml
Type: String
Parameter Sets: ListWhereMember
Aliases: UserKey

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

### Google.Apis.Admin.Directory.directory_v1.Data.Group
## NOTES

## RELATED LINKS
