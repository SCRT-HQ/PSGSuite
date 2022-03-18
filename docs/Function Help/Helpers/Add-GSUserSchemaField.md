# Add-GSUserSchemaField

## SYNOPSIS
Builds a UserPhone object to use when creating or updating a Schema

## SYNTAX

### InputObject (Default)
```
Add-GSUserSchemaField [-InputObject <SchemaFieldSpec[]>] [<CommonParameters>]
```

### Fields
```
Add-GSUserSchemaField [-FieldName <String>] [-FieldType <String>] [-Indexed] [-MultiValued]
 [-ReadAccessType <String>] [<CommonParameters>]
```

## DESCRIPTION
Builds a UserPhone object to use when creating or updating a Schema

## EXAMPLES

### EXAMPLE 1
```
New-GSUserSchema -SchemaName "SDK" -Fields (Add-GSUserSchemaField -FieldName "string" -FieldType STRING -ReadAccessType ADMINS_AND_SELF),(Add-GSUserSchemaField -FieldName "date" -FieldType DATE -ReadAccessType ADMINS_AND_SELF)
```

This command will create a schema named "SDK" with two fields, "string" and "date", readable by ADMINS_AND_SELF

## PARAMETERS

### -FieldName
The name of the field

```yaml
Type: String
Parameter Sets: Fields
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FieldType
The type of the field.


* Acceptable values are:
* "BOOL": Boolean values.
* "DATE": Dates in ISO-8601 format: http://www.w3.org/TR/NOTE-datetime
* "DOUBLE": Double-precision floating-point values.
* "EMAIL": Email addresses.
* "INT64": 64-bit integer values.
* "PHONE": Phone numbers.
* "STRING": String values.

```yaml
Type: String
Parameter Sets: Fields
Aliases:

Required: False
Position: Named
Default value: STRING
Accept pipeline input: False
Accept wildcard characters: False
```

### -Indexed
Switch specifying whether the field is indexed or not.
Default: true

```yaml
Type: SwitchParameter
Parameter Sets: Fields
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
Parameter description

```yaml
Type: SchemaFieldSpec[]
Parameter Sets: InputObject
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -MultiValued
A switch specifying whether this is a multi-valued field or not.
Default: false

```yaml
Type: SwitchParameter
Parameter Sets: Fields
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReadAccessType
Parameter description

```yaml
Type: String
Parameter Sets: Fields
Aliases:

Required: False
Position: Named
Default value: ADMINS_AND_SELF
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Admin.Directory.directory_v1.Data.SchemaFieldSpec
## NOTES

## RELATED LINKS
