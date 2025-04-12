# Update-GSMobileDevice

## SYNOPSIS
Updates a mobile device with the action specified

## SYNTAX

```
Update-GSMobileDevice [-ResourceId] <String[]> [-Action] <String> [<CommonParameters>]
```

## DESCRIPTION
Updates a mobile device with the action specified

## EXAMPLES

### EXAMPLE 1
```
Update-GSMobileDevice -ResourceId 'AFiQxQ8Qgd-rouSmcd2UnuvhYV__WXdacTgJhPEA1QoQJrK1hYbKJXm-8JFlhZOjBF4aVbhleS2FVQk5lI069K2GULpteTlLVpKLJFSLSL' -Action approve
```

Approves the mobile device with the specified Id

## PARAMETERS

### -Action
The action to be performed on the device.

Acceptable values are:
* "admin_account_wipe": Remotely wipes only G Suite data from the device.
See the administration help center for more information.
* "admin_remote_wipe": Remotely wipes all data on the device.
See the administration help center for more information.
* "approve": Approves the device.
If you've selected Enable device activation, devices that register after the device activation setting is enabled will need to be approved before they can start syncing with your domain.
Enabling device activation forces the device user to install the Device Policy app to sync with G Suite.
* "block": Blocks access to G Suite data (mail, calendar, and contacts) on the device.
The user can still access their mail, calendar, and contacts from a desktop computer or mobile browser.
* "cancel_remote_wipe_then_activate": Cancels a remote wipe of the device and then reactivates it.
* "cancel_remote_wipe_then_block": Cancels a remote wipe of the device and then blocks it.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceId
The unique Id of the mobile device you would like to update

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Admin.Directory.directory_v1.Data.MobileDevice
## NOTES

## RELATED LINKS
