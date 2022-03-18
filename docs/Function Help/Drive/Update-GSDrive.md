# Update-GSDrive

## SYNOPSIS
Update metatdata for a Shared Drive

## SYNTAX

```
Update-GSDrive [-DriveId] <String> [[-User] <String>] [-Name <String>] [-CanAddChildren]
 [-CanChangeDriveBackground] [-CanComment] [-CanCopy] [-CanDeleteDrive] [-CanDownload] [-CanEdit]
 [-CanListChildren] [-CanManageMembers] [-CanReadRevisions] [-CanRemoveChildren] [-CanRename] [-CanRenameDrive]
 [-CanShare] [<CommonParameters>]
```

## DESCRIPTION
Update metatdata for a Shared Drive

## EXAMPLES

### EXAMPLE 1
```
Update-GSDrive -DriveId '0AJ8Xjq3FcdCKUk9PVA' -Name "HR Document Repo"
```

Updated the Shared Drive with a new name, "HR Document Repo"

## PARAMETERS

### -CanAddChildren
Whether the current user can add children to folders in this Shared Drive

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

### -CanChangeDriveBackground
Whether the current user can change the background of this Shared Drive

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: CanChangeTeamDriveBackground

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -CanComment
Whether the current user can comment on files in this Shared Drive

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

### -CanCopy
Whether the current user can copy files in this Shared Drive

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

### -CanDeleteDrive
Whether the current user can delete this Shared Drive.
Attempting to delete the Shared Drive may still fail if there are untrashed items inside the Shared Drive

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: CanDeleteTeamDrive

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -CanDownload
Whether the current user can download files in this Shared Drive

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

### -CanEdit
Whether the current user can edit files in this Shared Drive

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

### -CanListChildren
Whether the current user can list the children of folders in this Shared Drive

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

### -CanManageMembers
Whether the current user can add members to this Shared Drive or remove them or change their role

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

### -CanReadRevisions
Whether the current user can read the revisions resource of files in this Shared Drive

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

### -CanRemoveChildren
Whether the current user can remove children from folders in this Shared Drive

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

### -CanRename
Whether the current user can rename files or folders in this Shared Drive

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

### -CanRenameDrive
Whether the current user can rename this Shared Drive

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: CanRenameTeamDrive

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -CanShare
Whether the current user can share files or folders in this Shared Drive

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

### -DriveId
The unique Id of the Shared Drive to update

```yaml
Type: String
Parameter Sets: (All)
Aliases: Id, TeamDriveId

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the Shared Drive

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

### -User
The user to create the Shared Drive for (must have permissions to create Shared Drives)

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
