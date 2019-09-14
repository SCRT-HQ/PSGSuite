# Set-GSUserSchema

## SYNOPSIS
Hard-sets a schema's configuration

## SYNTAX

```
Set-GSUserSchema [-SchemaId] <String> [-SchemaName <String>] [-Fields <SchemaFieldSpec[]>] [<CommonParameters>]
```

## DESCRIPTION
Hard-sets a schema's configuration

## EXAMPLES

### EXAMPLE 1
```
Set-GSUserSchema -SchemaId "9804800jfl08917304j" -SchemaName "SDK_2" -Fields (Add-GSUserSchemaField -FieldName "string2" -FieldType STRING -ReadAccessType ADMINS_AND_SELF)
```

This command will set the schema Id '9804800jfl08917304j' with the name "SDK_2" and one field "string2" readable by ADMINS_AND_SELF

## PARAMETERS

### -Fields
New schema fields to set

Expects SchemaFieldSpec objects.
You can create these with the helper function Add-GSUserSchemaField, i.e.: Add-GSUserSchemaField -FieldName "date" -FieldType DATE -ReadAccessType ADMINS_AND_SELF

```yaml
Type: SchemaFieldSpec[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SchemaId
The unique Id of the schema to set

```yaml
Type: String
Parameter Sets: (All)
Aliases: Schema

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SchemaName
The new schema name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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
