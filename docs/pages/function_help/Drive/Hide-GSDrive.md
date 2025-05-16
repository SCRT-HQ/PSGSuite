# Hide-GSDrive

## SYNOPSIS
Hides a Shared Drive from the default view

## SYNTAX

```
Hide-GSDrive -DriveId <String[]> [[-User] <String>] [<CommonParameters>]
```

## DESCRIPTION
Hides a Shared Drive from the default view

## EXAMPLES

### EXAMPLE 1
```
Hide-GSDrive -DriveId $driveIds
```

Hides the specified DriveIds for the AdminEmail user

## PARAMETERS

### -DriveId
The unique Id of the Shared Drive to hide

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
The email or unique Id of the user who you'd like to hide the Shared Drive for.

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
