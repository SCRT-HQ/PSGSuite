# Restore-GSUser

## SYNOPSIS
Restores a deleted user

## SYNTAX

### User (Default)
```
Restore-GSUser [-User] <String[]> [[-OrgUnitPath] <String>] [-RecentOnly] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Id
```
Restore-GSUser -Id <Int32> [[-OrgUnitPath] <String>] [-RecentOnly] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Restores a deleted user

## EXAMPLES

### EXAMPLE 1
```
Restore-GSUser -User john.smith@domain.com -OrgUnitPath "/Users/Rehires" -Confirm:$false
```

Restores user John Smith to the OrgUnitPath "/Users/Rehires", skipping confirmation.
If multiple accounts with the email "john.smith@domain.com" are found, the user is presented with a dialog to choose which account to restore based on deletion time

## PARAMETERS

### -Id
The unique Id of the user to restore

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -OrgUnitPath
The OrgUnitPath to restore the user to

Defaults to the root OrgUnit "/"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: /
Accept pipeline input: False
Accept wildcard characters: False
```

### -RecentOnly
If multiple users with the email address are found in deleted users, this forces restoration of the most recently deleted user.
If not passed and multiple deleted users are found with the specified email address, you will be prompted to choose which you'd like to restore based on deletion time

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The email address of the user to restore

```yaml
Type: String[]
Parameter Sets: User
Aliases: PrimaryEmail, UserKey, Mail

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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

### Google.Apis.Admin.Directory.directory_v1.Data.User
## NOTES

## RELATED LINKS
