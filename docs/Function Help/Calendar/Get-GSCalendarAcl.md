# Get-GSCalendarAcl

## SYNOPSIS
Gets the Access Control List for a calendar

## SYNTAX

### List (Default)
```
Get-GSCalendarAcl [[-User] <String[]>] [-CalendarId <String[]>] [-PageSize <Int32>] [-Limit <Int32>]
 [<CommonParameters>]
```

### Get
```
Get-GSCalendarAcl [[-User] <String[]>] [-CalendarId <String[]>] [-RuleId <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets the Access Control List for a calendar

## EXAMPLES

### EXAMPLE 1
```
Get-GSCalendarACL -User me -CalendarID "primary"
```

This gets the ACL on the primary calendar of the AdminUser.

## PARAMETERS

### -CalendarId
The calendar ID of the calendar you would like to list ACLS for.

Defaults to the user's primary calendar

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Id

Required: False
Position: Named
Default value: Primary
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Limit
The maximum amount of results you want returned.
Exclude or set to 0 to return all results

```yaml
Type: Int32
Parameter Sets: List
Aliases: First

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
Maximum number of events returned on one result page.

```yaml
Type: Int32
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: 2500
Accept pipeline input: False
Accept wildcard characters: False
```

### -RuleId
The Id of the Rule you would like to retrieve specifically.
Leave empty to return the full ACL list instead.

```yaml
Type: String
Parameter Sets: Get
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The primary email or UserID of the user.
You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

Defaults to the AdminEmail in the config

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail

Required: False
Position: 1
Default value: $Script:PSGSuite.AdminEmail
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Calendar.v3.Data.AclRule
## NOTES

## RELATED LINKS
