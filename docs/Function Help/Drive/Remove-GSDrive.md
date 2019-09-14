# Remove-GSDrive

## SYNOPSIS
Removes a Shared Drive

## SYNTAX

```
Remove-GSDrive -DriveId <String[]> [[-User] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes a Shared Drive

## EXAMPLES

### EXAMPLE 1
```
Remove-Drive -DriveId "0AJ8Xjq3FcdCKUk9PVA" -Confirm:$false
```

Removes the Shared Drive '0AJ8Xjq3FcdCKUk9PVA', skipping confirmation

## PARAMETERS

### -DriveId
The Id of the Shared Drive to remove

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Id, TeamDriveId

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -User
The email or unique Id of the user with permission to delete the Shared Drive

Defaults to the AdminEmail user

```yaml
Type: String
Parameter Sets: (All)
Aliases: Owner, PrimaryEmail, UserKey, Mail

Required: False
Position: 1
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
