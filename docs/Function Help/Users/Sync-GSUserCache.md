# Sync-GSUserCache

## SYNOPSIS
Syncs your GS Users to a hashtable contained in the global scoped variable $global:GSUserCache for fast lookups in scripts.

## SYNTAX

```
Sync-GSUserCache [[-Filter] <String[]>] [-Keys <String[]>] [-PassThru] [<CommonParameters>]
```

## DESCRIPTION
Syncs your GS Users to a hashtable contained in the global scoped variable $global:GSUserCache for fast lookups in scripts.

## EXAMPLES

### EXAMPLE 1
```
Sync-GSUserCache -Filter 'IsSuspended=False'
```

Fills the $global:GSUserCache hashtable with all active users using the default Keys.

## PARAMETERS

### -Filter
The filter to use with Get-GSUser to populate your UserCache with.

Defaults to * (all users).

If you'd like to limit to just Active (not suspended) users, use the following filter:

    "IsSuspended -eq '$false'"

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: @('*')
Accept pipeline input: False
Accept wildcard characters: False
```

### -Keys
The user properties to use as keys in the Cache hash.

Available values are:
* PrimaryEmail
* Id
* Alias

Defaults to all 3.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: @('PrimaryEmail','Id','Alias')
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
If $true, returns the hashtable as output

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
