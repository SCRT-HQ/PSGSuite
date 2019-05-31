function Update-GSChromeOSDevice {
    <#
    .SYNOPSIS
    Updates a ChromeOS device

    .DESCRIPTION
    Updates a ChromeOS device

    .PARAMETER ResourceId
    The unique ID of the device you would like to update.

    .PARAMETER Action
    Action to be taken on the Chrome OS device.

    Acceptable values are:
    * "deprovision": Remove a device from management that is no longer active, being resold, or is being submitted for return / repair, use the deprovision action to dissociate it from management.
    * "disable": If you believe a device in your organization has been lost or stolen, you can disable the device so that no one else can use it. When a device is disabled, all the user can see when turning on the Chrome device is a screen telling them that it’s been disabled, and your desired contact information of where to return the device.
        Note: Configuration of the message to appear on a disabled device must be completed within the admin console.
    "reenable": Re-enable a disabled device when a misplaced device is found or a lost device is returned. You can also use this feature if you accidentally mark a Chrome device as disabled.
        Note: The re-enable action can only be performed on devices marked as disabled.

    .PARAMETER DeprovisionReason
    Only used when the action is deprovision. With the deprovision action, this field is required.

    Note: The deprovision reason is audited because it might have implications on licenses for perpetual subscription customers.

    Acceptable values are:
    * "different_model_replacement": Use if you're upgrading or replacing your device with a newer model of the same device.
    * "retiring_device": Use if you're reselling, donating, or permanently removing the device from use.
    * "same_model_replacement": Use if a hardware issue was encountered on a device and it is being replaced with the same model or a like-model replacement from a repair vendor / manufacturer.

    .PARAMETER AnnotatedAssetId
    The asset identifier as noted by an administrator or specified during enrollment.

    .PARAMETER AnnotatedLocation
    The address or location of the device as noted by the administrator. Maximum length is 200 characters. Empty values are allowed.

    .PARAMETER AnnotatedUser
    The user of the device as noted by the administrator. Maximum length is 100 characters. Empty values are allowed.

    .PARAMETER Notes
    Notes about this device added by the administrator. This property can be searched with the list method's query parameter. Maximum length is 500 characters. Empty values are allowed.

    .PARAMETER OrgUnitPath
    Full path of the target organizational unit or its ID that you would like to move the device to.

    .EXAMPLE
    Update-GSChromeOSDevice -ResourceId 'AFiQxQ8Qgd-rouSmcd2UnuvhYV__WXdacTgJhPEA1QoQJrK1hYbKJXm-8JFlhZOjBF4aVbhleS2FVQk5lI069K2GULpteTlLVpKLJFSLSL' -Action deprovision -DeprovisionReason retiring_device

    Deprovisions the retired ChromeOS device
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.ChromeOSDevice')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias('Id','Device','DeviceId')]
        [String[]]
        $ResourceId,
        [parameter(Mandatory = $false)]
        [ValidateSet('deprovision','disable','reenable')]
        [String]
        $Action,
        [parameter(Mandatory = $false)]
        [ValidateSet('different_model_replacement','retiring_device','same_model_replacement')]
        [String]
        $DeprovisionReason,
        [parameter(Mandatory = $false)]
        [String]
        $AnnotatedAssetId,
        [parameter(Mandatory = $false)]
        [AllowNull()]
        [String]
        $AnnotatedLocation,
        [parameter(Mandatory = $false)]
        [AllowNull()]
        [String]
        $AnnotatedUser,
        [parameter(Mandatory = $false)]
        [AllowNull()]
        [String]
        $Notes,
        [parameter(Mandatory = $false)]
        [String]
        $OrgUnitPath

    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.device.chromeos'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
        $customerId = if ($Script:PSGSuite.CustomerID) {
            $Script:PSGSuite.CustomerID
        }
        else {
            "my_customer"
        }
        $bodyUpdated = $false
    }
    Process {
        $body = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.ChromeOsDevice'
        foreach ($key in $PSBoundParameters.Keys | Where-Object {$_ -in @('Action','OrgUnitPath') -or $_ -in $body.PSObject.Properties.Name}) {
            switch ($key) {
                Action {
                    try {
                        $actionBody = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.ChromeOSDeviceAction' -Property @{
                            Action = $Action
                        }
                        if ($PSBoundParameters.Keys -contains 'DeprovisionReason') {
                            $actionBody.DeprovisionReason = $PSBoundParameters['DeprovisionReason']
                        }
                        foreach ($dev in $ResourceId) {
                            Write-Verbose "Updating Chrome OS Device '$dev' with Action '$Action'"
                            $request = $service.Chromeosdevices.Action($actionBody,$customerId,$dev)
                            $request.Execute()
                            Write-Verbose "Chrome OS Device was successfully updated"
                        }
                    }
                    catch {
                        if ($ErrorActionPreference -eq 'Stop') {
                            $PSCmdlet.ThrowTerminatingError($_)
                        }
                        else {
                            Write-Error $_
                        }
                    }
                }
                OrgUnitPath {
                    try {
                        Move-GSChromeOSDevice -ResourceId $ResourceId -OrgUnitPath $OrgUnitPath
                    }
                    catch {
                        if ($ErrorActionPreference -eq 'Stop') {
                            $PSCmdlet.ThrowTerminatingError($_)
                        }
                        else {
                            Write-Error $_
                        }
                    }
                }
                default {
                    if ($key -in $body.PSObject.Properties.Name) {
                        $bodyUpdated = $true
                        $body.$key = $PSBoundParameters[$key]
                    }
                }
            }
        }
        if ($bodyUpdated) {
            foreach ($dev in $ResourceId) {
                try {
                    Write-Verbose "Updating Chrome OS Device '$dev'"
                    $request = $service.Chromeosdevices.Patch($actionBody,$customerId,$dev)
                    $request.Execute()
                }
                catch {
                    if ($ErrorActionPreference -eq 'Stop') {
                        $PSCmdlet.ThrowTerminatingError($_)
                    }
                    else {
                        Write-Error $_
                    }
                }
            }
        }
    }
}
