# New-GSGroup

## SYNOPSIS
Creates a new Google Group

## SYNTAX

```
New-GSGroup [-Email] <String> [-Name] <String> [[-Description] <String>] [<CommonParameters>]
```

## DESCRIPTION
Creates a new Google Group

## EXAMPLES

### EXAMPLE 1
```
New-GSGroup -Email appdev -Name "Application Developers" -Description "App Dev team members"
```

Creates a new group named "Application Developers" with the email "appdev@domain.com" and description "App Dev team members"

## PARAMETERS

### -Description
The description of the new group

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Email
The desired email of the new group.
If the group already exists, a GoogleApiException will be thrown.
You can exclude the '@domain.com' to insert the Domain in the config

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
The name of the new group

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
