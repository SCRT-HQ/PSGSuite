# Get-GSUserSchema

## SYNOPSIS
Gets custom user schema info

## SYNTAX

```
Get-GSUserSchema [[-SchemaId] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Gets custom user schema info

## EXAMPLES

### EXAMPLE 1
```
Get-GSUserSchema
```

Gets the list of custom user schemas

## PARAMETERS

### -SchemaId
The Id or Name of the user schema you would like to return info for.
If excluded, gets the full list of user schemas

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Schema

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Admin.Directory.directory_v1.Data.Schema
## NOTES

## RELATED LINKS
