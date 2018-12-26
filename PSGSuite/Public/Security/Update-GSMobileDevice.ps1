function Update-GSMobileDevice {
    <#
    .SYNOPSIS
    Updates a mobile device with the action specified

    .DESCRIPTION
    Updates a mobile device with the action specified

    .PARAMETER ResourceID
    The unique Id of the mobile device you would like to update

    .PARAMETER Action
    The action to be performed on the device.

    Acceptable values are:
    * "admin_account_wipe": Remotely wipes only G Suite data from the device. See the administration help center for more information.
    * "admin_remote_wipe": Remotely wipes all data on the device. See the administration help center for more information.
    * "approve": Approves the device. If you've selected Enable device activation, devices that register after the device activation setting is enabled will need to be approved before they can start syncing with your domain. Enabling device activation forces the device user to install the Device Policy app to sync with G Suite.
    * "block": Blocks access to G Suite data (mail, calendar, and contacts) on the device. The user can still access their mail, calendar, and contacts from a desktop computer or mobile browser.
    * "cancel_remote_wipe_then_activate": Cancels a remote wipe of the device and then reactivates it.
    * "cancel_remote_wipe_then_block": Cancels a remote wipe of the device and then blocks it.

    .EXAMPLE
    Update-GSMobileDevice -ResourceId 'AFiQxQ8Qgd-rouSmcd2UnuvhYV__WXdacTgJhPEA1QoQJrK1hYbKJXm-8JFlhZOjBF4aVbhleS2FVQk5lI069K2GULpteTlLVpKLJFSLSL' -Action approve

    Approves the mobile device with the specified Id
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.MobileDevice')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $ResourceId,
        [parameter(Mandatory = $true)]
        [ValidateSet('admin_account_wipe','admin_remote_wipe','approve','block','cancel_remote_wipe_then_activate','cancel_remote_wipe_then_block')]
        [String]
        $Action

    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.device.mobile'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
        $customerId = if ($Script:PSGSuite.CustomerID) {
            $Script:PSGSuite.CustomerID
        }
        else {
            "my_customer"
        }
        $body = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.MobileDeviceAction' -Property @{
            Action = $Action
        }
    }
    Process {
        try {
            foreach ($R in $ResourceId) {
                Write-Verbose "Updating Mobile Device '$R' with Action '$Action'"
                $request = $service.Mobiledevices.Action($body,$customerId,$R)
                $request.Execute()
                Write-Verbose "Mobile Device was successfully updated"
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
}
