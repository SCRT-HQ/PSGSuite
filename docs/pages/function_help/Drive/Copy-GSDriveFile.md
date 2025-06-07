# Copy-GSDriveFile

## SYNOPSIS
Make a copy of a file in Drive

## SYNTAX

### Depth (Default)
```
Copy-GSDriveFile [-FileID] <String> [-User <String>] [-Name <String>] [-Description <String>]
 [-Parents <String[]>] [-Projection <String>] [<CommonParameters>]
```

### Fields
```
Copy-GSDriveFile [-FileID] <String> [-User <String>] [-Name <String>] [-Description <String>]
 [-Parents <String[]>] [-Fields <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Make a copy of a file in Drive

## EXAMPLES

### EXAMPLE 1
```
Copy-GSDriveFile -FileId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976' -Name "New Daily Checklist"
```

Copies the Drive file Id to a new Drive file named 'New Daily Checklist'

## PARAMETERS

### -Description
The description of the new Drive file copy

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

### -Fields
The specific fields to returned

```yaml
Type: String[]
Parameter Sets: Fields
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileID
The unique Id of the file to copy

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the new Drive file copy

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

### -Parents
The parent Ids of the new Drive file copy

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

### -Projection
The defined subset of fields to be returned

Available values are:
* "Minimal"
* "Standard"
* "Full"
* "Access"

```yaml
Type: String
Parameter Sets: Depth
Aliases: Depth

Required: False
Position: Named
Default value: Full
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The email or unique Id of the owner of the Drive file

Defaults to the AdminEmail user

```yaml
Type: String
Parameter Sets: (All)
Aliases: Owner, PrimaryEmail, UserKey, Mail

Required: False
Position: Named
Default value: $Script:PSGSuite.AdminEmail
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Drive.v3.Data.File
## NOTES

## RELATED LINKS
