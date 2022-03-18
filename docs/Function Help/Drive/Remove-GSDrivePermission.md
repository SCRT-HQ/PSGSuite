# Remove-GSDrivePermission

## SYNOPSIS
Removes a permission from a Drive file

## SYNTAX

```
Remove-GSDrivePermission [-FileId] <String> [[-User] <String>] -PermissionId <String> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Removes a permission from a Drive file

## EXAMPLES

### EXAMPLE 1
```
Remove-GSDrivePermission -FileId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976' -PermissionID 'sdfadsfsdafasd'
```

Removes the permission from the drive.

### EXAMPLE 2
```
Get-GSDrivePermission -FileId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976' | ? {$_.Type -eq 'group'} | Remove-GSDrivePermission
```

Gets the permissions assigned to groups and removes them.

## PARAMETERS

### -FileId
The unique Id of the Drive file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PermissionId
The unique Id of the permission you are trying to remove.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Id

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
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

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

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

## NOTES

## RELATED LINKS
