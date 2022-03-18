# Get-GSDataTransferApplication

## SYNOPSIS
Gets the list of available Data Transfer Applications and their parameters

## SYNTAX

```
Get-GSDataTransferApplication [[-ApplicationId] <String[]>] [-PageSize <Int32>] [-Limit <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
Gets the list of available Data Transfer Applications and their parameters

## EXAMPLES

### EXAMPLE 1
```
Get-GSDataTransferApplication
```

Gets the list of available Data Transfer Applications

## PARAMETERS

### -ApplicationId
The Application Id of the Data Transfer Application you would like to return info for specifically.
Exclude to return the full list

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
The maximum amount of results you want returned.
Exclude or set to 0 to return all results

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: First

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
PageSize of the result set.

Defaults to 500 (although it's typically a much smaller number for most Customers)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 500
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Admin.DataTransfer.datatransfer_v1.Data.Application
## NOTES

## RELATED LINKS
