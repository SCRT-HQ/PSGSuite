# Get-GSUser

## SYNOPSIS
Gets the specified G SUite User or a list of Users

## SYNTAX

### Get (Default)
```
Get-GSUser [[-User] <String[]>] [-Projection <String>] [-CustomFieldMask <String>] [-ViewType <String>]
 [-Fields <String[]>] [<CommonParameters>]
```

### List
```
Get-GSUser [-Filter <String[]>] [-Domain <String>] [-SearchBase <String>] [-SearchScope <String>]
 [-ShowDeleted] [-Projection <String>] [-CustomFieldMask <String>] [-ViewType <String>] [-Fields <String[]>]
 [-PageSize <Int32>] [-Limit <Int32>] [-OrderBy <String>] [-SortOrder <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets the specified G SUite User.
Designed for parity with Get-ADUser as much as possible

## EXAMPLES

### EXAMPLE 1
```
Get-GSUser
```

Gets the user info for the AdminEmail on the config

### EXAMPLE 2
```
Get-GSUser -Filter *
```

Gets the list of users

### EXAMPLE 3
```
Get-GSUser -Filter "IsAdmin -eq '$true'"
```

Gets the list of SuperAdmin users

### EXAMPLE 4
```
Get-GSUser -Filter "IsEnrolledIn2Sv -eq '$false'" -SearchBase /Contractors -SearchScope Subtree
```

Gets the list of users not currently enrolled in 2-Step Verification from the Contractors OrgUnit or any OrgUnits underneath it

## PARAMETERS

### -CustomFieldMask
A comma-separated list of schema names.
All fields from these schemas are fetched.
This should only be set when using '-Projection Custom'

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

### -Domain
The specific domain you would like to list users for.
Useful for customers with multiple domains.

```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fields
The specific fields to fetch for this user

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
Query string for searching user fields

For more information on constructing user queries, see: https://developers.google.com/admin-sdk/directory/v1/guides/search-users

PowerShell filter syntax here is supported as "best effort".
Please use Google's filter operators and syntax to ensure best results

```yaml
Type: String[]
Parameter Sets: List
Aliases: Query

Required: False
Position: Named
Default value: *
Accept pipeline input: False
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

### -OrderBy
Property to use for sorting results.

Acceptable values are:
* "Email": Primary email of the user.
* "FamilyName": User's family name.
* "GivenName": User's given name.

```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
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
Default value: 500
Accept pipeline input: False
Accept wildcard characters: False
```

### -Projection
What subset of fields to fetch for this user

Acceptable values are:
* "Basic": Do not include any custom fields for the user
* "Custom": Include custom fields from schemas requested in customFieldMask
* "Full": Include all fields associated with this user (default for this module)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Full
Accept pipeline input: False
Accept wildcard characters: False
```

### -SearchBase
The organizational unit path that you would like to list users from

```yaml
Type: String
Parameter Sets: List
Aliases: OrgUnitPath

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SearchScope
The depth at which to return the list of users

Available values are:
* "Base": only return the users specified in the SearchBase
* "Subtree": return the full list of users underneath the specified SearchBase
* "OneLevel": return the SearchBase and the Users directly underneath it

```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: Subtree
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowDeleted
Returns deleted users

```yaml
Type: SwitchParameter
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SortOrder
Whether to return results in ascending or descending order.

Acceptable values are:
* "Ascending": Ascending order.
* "Descending": Descending order.

```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The primary email or UserID of the user who you are trying to get info for.
You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

Defaults to the AdminEmail in the config

```yaml
Type: String[]
Parameter Sets: Get
Aliases: PrimaryEmail, UserKey, Mail, Email, Id

Required: False
Position: 1
Default value: $Script:PSGSuite.AdminEmail
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -ViewType
Whether to fetch the administrator-only or domain-wide public view of the user.
For more information, see Retrieve a user as a non-administrator

Acceptable values are:
* "Admin_View": Results include both administrator-only and domain-public fields for the user.
(default)
* "Domain_Public": Results only include fields for the user that are publicly visible to other users in the domain.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Admin_View
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Admin.Directory.directory_v1.Data.User
## NOTES

## RELATED LINKS
