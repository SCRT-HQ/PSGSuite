# Get-GSUsageReport

## SYNOPSIS
Retrieves the usage report for the specified type.

Defaults to Customer Usage Report type.

## SYNTAX

### Customer (Default)
```
Get-GSUsageReport [-Date <DateTime>] [-Parameters <String[]>] [-Flat] [-Raw] [<CommonParameters>]
```

### User
```
Get-GSUsageReport [-Date <DateTime>] -UserKey <String> [-Filters <String[]>] [-Parameters <String[]>]
 [-PageSize <Int32>] [-Limit <Int32>] [-Flat] [-Raw] [<CommonParameters>]
```

### Entity
```
Get-GSUsageReport [-Date <DateTime>] -EntityType <String> [-EntityKey <String>] [-Filters <String[]>]
 [-Parameters <String[]>] [-PageSize <Int32>] [-Limit <Int32>] [-Flat] [-Raw] [<CommonParameters>]
```

## DESCRIPTION
Retrieves the usage report for the specified type.

Defaults to Customer Usage Report type.

## EXAMPLES

### EXAMPLE 1
```
Get-GSUsageReport -Date (Get-Date).AddDays(-30)
```

Gets the Customer Usage report from 30 days prior

## PARAMETERS

### -Date
Represents the date for which the data is to be fetched.
Defaults to 3 days before the current date.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-Date).AddDays(-3)
Accept pipeline input: False
Accept wildcard characters: False
```

### -EntityKey
\[Entity Usage Report\] Represents the key of object for which the data should be filtered.

Use 'all' to retrieve the report for all users.

```yaml
Type: String
Parameter Sets: Entity
Aliases:

Required: False
Position: Named
Default value: All
Accept pipeline input: False
Accept wildcard characters: False
```

### -EntityType
\[Entity Usage Report\] Type of object.
Should be one of:
* gplus_communities

```yaml
Type: String
Parameter Sets: Entity
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filters
Represents the set of filters including parameter operator value

```yaml
Type: String[]
Parameter Sets: User, Entity
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Flat
If $true, returns a flattened object for easy parsing.

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

### -Limit
The maximum amount of results you want returned.
Exclude or set to 0 to return all results

```yaml
Type: Int32
Parameter Sets: User, Entity
Aliases: First

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
Maximum number of results to return.
Maximum allowed is 1000

```yaml
Type: Int32
Parameter Sets: User, Entity
Aliases: MaxResults

Required: False
Position: Named
Default value: 1000
Accept pipeline input: False
Accept wildcard characters: False
```

### -Parameters
Represents the application name, parameter name pairs to fetch in csv as app_name1:param_name1

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Raw
If $true, returns the raw, unformatted results.

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

### -UserKey
\[User Usage Report\] Represents the profile id or the user email for which the data should be filtered.

Use 'all' to retrieve the report for all users.

```yaml
Type: String
Parameter Sets: User
Aliases:

Required: True
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
