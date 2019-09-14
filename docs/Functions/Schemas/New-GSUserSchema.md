# New-GSUserSchema

## SYNOPSIS
Creates a new user schema

## SYNTAX

```
New-GSUserSchema [-SchemaName] <String> [-Fields] <SchemaFieldSpec[]> [<CommonParameters>]
```

## DESCRIPTION
Creates a new user schema

## EXAMPLES

### EXAMPLE 1
```
New-GSUserSchema -SchemaName "SDK" -Fields (Add-GSUserSchemaField -FieldName "string" -FieldType STRING -ReadAccessType ADMINS_AND_SELF),(Add-GSUserSchemaField -FieldName "date" -FieldType DATE -ReadAccessType ADMINS_AND_SELF)
```

This command will create a schema named "SDK" with two fields, "string" and "date", readable by ADMINS_AND_SELF

## PARAMETERS

### -Fields
New schema fields to set

Expects SchemaFieldSpec objects.
You can create these with the helper function Add-GSUserSchemaField, i.e.: Add-GSUserSchemaField -FieldName "date" -FieldType DATE -ReadAccessType ADMINS_AND_SELF

```yaml
Type: SchemaFieldSpec[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SchemaName
The name of the schema to create

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Admin.Directory.directory_v1.Data.Schema
## NOTES

## RELATED LINKS
