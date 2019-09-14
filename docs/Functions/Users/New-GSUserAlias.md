# New-GSUserAlias

## SYNOPSIS
Creates a new alias for a G Suite user

## SYNTAX

```
New-GSUserAlias [-User] <String> [-Alias] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Creates a new alias for a G Suite user

## EXAMPLES

### EXAMPLE 1
```
New-GSUserAlias -User john.smith@domain.com -Alias 'jsmith@domain.com','johns@domain.com'
```

Creates 2 new aliases for user John Smith as 'jsmith@domain.com' and 'johns@domain.com'

## PARAMETERS

### -Alias
The alias or list of aliases to create for the user

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

### -User
The user to create the alias for

```yaml
Type: String
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail, Email

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Admin.Directory.directory_v1.Data.Alias
## NOTES

## RELATED LINKS
