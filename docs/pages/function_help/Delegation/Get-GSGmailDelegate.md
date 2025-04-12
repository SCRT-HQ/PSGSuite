# Get-GSGmailDelegate

## SYNOPSIS
Gets delegates for the specified account.

## SYNTAX

```
Get-GSGmailDelegate [[-User] <String[]>] [[-Delegate] <String>] [-NoGroupCheck] [<CommonParameters>]
```

## DESCRIPTION
Gets delegates for the specified account.

## EXAMPLES

### EXAMPLE 1
```
Get-GSGmailDelegate -User tony@domain.com
```

Gets the list of users who have delegate access to Tony's inbox.

## PARAMETERS

### -Delegate
The specific delegate to get.
If excluded returns the list of delegates for the user.

```yaml
Type: String
Parameter Sets: (All)
Aliases: To

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoGroupCheck
By default, this will check if the User email is a group email which cannot be delegated if the attempt to delegate access fails.

Include this switch to prevent the group check and return the original error.

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

### -User
User's email to get delegates for.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: From, Delegator

Required: False
Position: 1
Default value: $Script:PSGSuite.AdminEmail
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Gmail.v1.Data.Delegate
## NOTES

## RELATED LINKS
