# Get-GSDrivePermission

## SYNOPSIS
Gets permission information for a Drive file

## SYNTAX

### List (Default)
```
Get-GSDrivePermission [-FileId] <String> [[-User] <String>] [-PageSize <Int32>] [-Limit <Int32>]
 [<CommonParameters>]
```

### Get
```
Get-GSDrivePermission [-FileId] <String> [[-User] <String>] [-PermissionId <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Gets permission information for a Drive file

## EXAMPLES

### EXAMPLE 1
```
Get-GSDrivePermission -FileId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976'
```

Gets the list of permissions for the file Id

## PARAMETERS

### -FileId
The unique Id of the Drive file

```yaml
Type: String
Parameter Sets: (All)
Aliases: Id

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
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

### -PageSize
The page size of the result set

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

### -PermissionId
The unique Id of the permission you are trying to get.
If excluded, the list of permissions for the Drive file will be returned instead

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

### -User
The email or unique Id of the user whose Drive file permission you are trying to get

Defaults to the AdminEmail user

```yaml
Type: String
Parameter Sets: (All)
Aliases: Owner, PrimaryEmail, UserKey, Mail

Required: False
Position: 2
Default value: $Script:PSGSuite.AdminEmail
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Drive.v3.Data.Permission
## NOTES

## RELATED LINKS
