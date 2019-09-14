# Update-GSChromeOSDevice

## SYNOPSIS
Updates a ChromeOS device

## SYNTAX

```
Update-GSChromeOSDevice [-ResourceId] <String[]> [-Action <String>] [-DeprovisionReason <String>]
 [-AnnotatedAssetId <String>] [-AnnotatedLocation <String>] [-AnnotatedUser <String>] [-Notes <String>]
 [-OrgUnitPath <String>] [<CommonParameters>]
```

## DESCRIPTION
Updates a ChromeOS device

## EXAMPLES

### EXAMPLE 1
```
Update-GSChromeOSDevice -ResourceId 'AFiQxQ8Qgd-rouSmcd2UnuvhYV__WXdacTgJhPEA1QoQJrK1hYbKJXm-8JFlhZOjBF4aVbhleS2FVQk5lI069K2GULpteTlLVpKLJFSLSL' -Action deprovision -DeprovisionReason retiring_device
```

Deprovisions the retired ChromeOS device

## PARAMETERS

### -Action
Action to be taken on the Chrome OS device.

Acceptable values are:
* "deprovision": Remove a device from management that is no longer active, being resold, or is being submitted for return / repair, use the deprovision action to dissociate it from management.
* "disable": If you believe a device in your organization has been lost or stolen, you can disable the device so that no one else can use it.
When a device is disabled, all the user can see when turning on the Chrome device is a screen telling them that itâ€™s been disabled, and your desired contact information of where to return the device.
    Note: Configuration of the message to appear on a disabled device must be completed within the admin console.
"reenable": Re-enable a disabled device when a misplaced device is found or a lost device is returned.
You can also use this feature if you accidentally mark a Chrome device as disabled.
    Note: The re-enable action can only be performed on devices marked as disabled.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AnnotatedAssetId
The asset identifier as noted by an administrator or specified during enrollment.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AnnotatedLocation
The address or location of the device as noted by the administrator.
Maximum length is 200 characters.
Empty values are allowed.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AnnotatedUser
The user of the device as noted by the administrator.
Maximum length is 100 characters.
Empty values are allowed.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeprovisionReason
Only used when the action is deprovision.
With the deprovision action, this field is required.

Note: The deprovision reason is audited because it might have implications on licenses for perpetual subscription customers.

Acceptable values are:
* "different_model_replacement": Use if you're upgrading or replacing your device with a newer model of the same device.
* "retiring_device": Use if you're reselling, donating, or permanently removing the device from use.
* "same_model_replacement": Use if a hardware issue was encountered on a device and it is being replaced with the same model or a like-model replacement from a repair vendor / manufacturer.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Notes
Notes about this device added by the administrator.
This property can be searched with the list method's query parameter.
Maximum length is 500 characters.
Empty values are allowed.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OrgUnitPath
Full path of the target organizational unit or its ID that you would like to move the device to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceId
The unique ID of the device you would like to update.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Id, Device, DeviceId

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

### Google.Apis.Admin.Directory.directory_v1.Data.ChromeOSDevice
## NOTES

## RELATED LINKS
