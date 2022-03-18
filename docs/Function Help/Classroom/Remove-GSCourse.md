# Remove-GSCourse

## SYNOPSIS
Removes an existing course.

## SYNTAX

```
Remove-GSCourse [-Id] <String> [-User <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes an existing course.

## EXAMPLES

### EXAMPLE 1
```
Remove-GSCourse -Id the-republic-s01 -Confirm:$false
```

## PARAMETERS

### -Id
Identifier for this course assigned by Classroom.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Alias

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The user to authenticate the request as

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $Script:PSGSuite.AdminEmail
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
