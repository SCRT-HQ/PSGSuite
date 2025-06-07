# Show-GSDrive

## SYNOPSIS
Shows (unhides) a Shared Drive in the default view

## SYNTAX

```
Show-GSDrive -DriveId <String[]> [[-User] <String>] [<CommonParameters>]
```

## DESCRIPTION
Shows (unhides) a Shared Drive in the default view

## EXAMPLES

### EXAMPLE 1
```
Show-GSDrive -DriveId $driveIds
```

Unhides the specified DriveIds for the AdminEmail user

## PARAMETERS

### -DriveId
The unique Id of the Shared Drive to unhide

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
The email or unique Id of the user who you'd like to unhide the Shared Drive for.

Defaults to the AdminEmail user.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Drive.v3.Data.Drive
## NOTES

## RELATED LINKS
