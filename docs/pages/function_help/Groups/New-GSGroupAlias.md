# New-GSGroupAlias

## SYNOPSIS
Creates a new alias for a G Suite group

## SYNTAX

```
New-GSGroupAlias [-Group] <String> [-Alias] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Creates a new alias for a G Suite group

## EXAMPLES

### EXAMPLE 1
```
New-GSGroupAlias -Group humanresources@domain.com -Alias 'hr@domain.com','hrhelp@domain.com'
```

Creates 2 new aliases for group Human Resources as 'hr@domain.com' and 'hrhelp@domain.com'

## PARAMETERS

### -Alias
The alias or list of aliases to create for the group

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Group
The group to create the alias for

```yaml
Type: String
Parameter Sets: (All)
Aliases: Email

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

### Google.Apis.Admin.Directory.directory_v1.Data.Alias
## NOTES

## RELATED LINKS
