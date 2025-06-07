# Get-GSGroupAlias

## SYNOPSIS
Gets the specified G SUite Group's aliases

## SYNTAX

```
Get-GSGroupAlias [-Group] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Gets the specified G SUite Group's aliases

## EXAMPLES

### EXAMPLE 1
```
Get-GSGroupAlias -Group hr
```

Gets the list of aliases for the group hr@domain.com

## PARAMETERS

### -Group
The primary email or ID of the group who you are trying to get aliases for.
You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

```yaml
Type: String[]
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
