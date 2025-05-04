Function Get-GSChromeOSDeviceCommand {
    <#
    .SYNOPSIS
    Gets a command that has been issued to a ChromeOS device.
    .DESCRIPTION
    Gets a command that has been issued to a ChromeOS device.
    .PARAMETER CustomerID
    The CustomerID of the domain containing the device. If unspecified the CustomerID defaults to 'my_customer'.
    .PARAMETER DeviceID
    The DeviceID of the device that has been issued the command.
    .PARAMETER CommandID
    The CommandID of the command to get.
    .EXAMPLE
    Get-GSChromeOSDeviceCommand -DeviceID 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' -CommandID 1234567890
    Gets command with CommandID '1234567890' that was issued to device with DeviceID 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'.
    .EXAMPLE
    Get-GSChromeOSDevice | Invoke-GSChromeOSDeviceCommand -CommandType 'WIPE_USERS' | Get-GSChromeOSDeviceCommand
    Gets all of the WIPE_USERS commands via the pipeline that were issued by Invoke-GSChromeOSDeviceCommand.
    .LINK
    https://developers.google.com/admin-sdk/directory/reference/rest/v1/customer.devices.chromeos.commands/get
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.DirectoryChromeosdevicesCommand')]
    Param
    (
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $True)]
        [string]
        $DeviceID,
        [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $True)]
        [String]
        $CustomerID = "my_customer",
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $True)]
        [Int64]
        $CommandID
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.device.chromeos.readonly'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        $verbString = "Getting command $commandID for ChromeOS device $DeviceID"
        try {
            Write-Verbose $verbString                 
            $Request = $Service.Customer.Devices.Chromeos.Commands.Get($CustomerID, $DeviceID, $CommandID)
            $Result = $Request.Execute()

            If ($null -ne $Result){
                $Result | Add-Member -MemberType NoteProperty -Name DeviceID -Value $DeviceID
                $Result | Add-Member -MemberType NoteProperty -Name CustomerID -Value $CustomerID
            }

            $Result
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
