# Get-GSGroupSettings

## SYNOPSIS
Gets a group's settings

## SYNTAX

```
Get-GSGroupSettings [-Identity] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Gets a group's settings

## EXAMPLES

### EXAMPLE 1
```
Get-GSGroupSettings admins
```

Gets the group settings for admins@domain.com

## PARAMETERS

### -Identity
The email of the group

If only the email name-part is passed, the full email will be contstructed using the Domain from the active config

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: GroupEmail, Group, Email

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Groupssettings.v1.Data.Groups
## NOTES

## RELATED LINKS
