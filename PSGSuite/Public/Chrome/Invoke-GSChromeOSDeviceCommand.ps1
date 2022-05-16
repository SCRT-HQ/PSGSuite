Function Invoke-GSChromeOSDeviceCommand {
    <#
    .SYNOPSIS
    Issues a command to a ChromeOS device.
    .DESCRIPTION
    Issues a command to a ChromeOS device.
    .PARAMETER CustomerID
    The CustomerID of the domain containing the device. If unspecified the CustomerID defaults to 'my_customer'.
    .PARAMETER DeviceID
    The DeviceID of the device to issue the command to.
    .PARAMETER CommandType
    The command to issue to the device. Available commands are:
    * REBOOT - Reboot the device. Can only be issued to Kiosk and managed guest session devices.
    * TAKE_A_SCREENSHOT - Take a screenshot of the device. Only available if the device is in Kiosk Mode.
    * SET_VOLUME - Set the volume of the device. Can only be issued to Kiosk and managed guest session devices.
    * WIPE_USERS - Wipe all the users off of the device. Executing this command in the device will remove all user profile data, but it will keep device policy and enrollment.
    * REMOTE_POWERWASH - Wipes the device by performing a power wash. Executing this command in the device will remove all data including user policies, device policies and enrollment policies. Warning: This will revert the device back to a factory state with no enrollment unless the device is subject to forced or auto enrollment. Use with caution, as this is an irreversible action!
    .PARAMETER Payload
    The payload for the command, provide it only if command supports it. The following commands support adding payload:
    * SET_VOLUME - The payload must be a value between 0 and 100.
    .EXAMPLE
    Invoke-GSChromeOSDeviceCommand -DeviceID 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' -CommandType 'SET_VOLUME' -Payload 50
    Issues a command to the device with DeviceID 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' to set the system volume level to 50%.
    .EXAMPLE
    Get-GSChromeOSDevice | Invoke-GSChromeOSDeviceCommand -CommandType 'WIPE_USERS'
    Gets all ChromeOS Devices from Google Directory and issues the 'WIPE_USERS' command to them.
    .LINK
    https://developers.google.com/admin-sdk/directory/reference/rest/v1/customer.devices.chromeos/issueCommand
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.DirectoryChromeosdevicesIssueCommandResponse')]
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    Param
    (
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $True)]
        [string[]]
        $DeviceID,
        [parameter(Mandatory = $false)]
        [String]
        $CustomerID = "my_customer",
        [parameter(Mandatory = $true)]
        [String]
        [Alias("Command")]
        [ValidateSet("REBOOT","TAKE_A_SCREENSHOT","SET_VOLUME","WIPE_USERS","REMOTE_POWERWASH")]
        $CommandType
    )
    DynamicParam {
        if ($CommandType -eq 'SET_VOLUME') {
            $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        
            $attribute = New-Object System.Management.Automation.ParameterAttribute
            $attribute.Mandatory = $True
            $attributeCollection.Add($attribute)

            $attribute = New-Object System.Management.Automation.AliasAttribute('Volume')
            $attributeCollection.Add($attribute)
            
            $attribute = New-Object System.Management.Automation.ValidateRangeAttribute(0, 100)
            $attributeCollection.Add($attribute)

            $Name = 'Payload'
            $dynParam = New-Object System.Management.Automation.RuntimeDefinedParameter($Name, [int], $attributeCollection)
            $paramDictionary.Add($Name, $dynParam)

            return $paramDictionary
        }

    }
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.device.chromeos'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams

        $RequestBody = New-Object -Type Google.Apis.Admin.Directory.directory_v1.Data.DirectoryChromeosdevicesIssueCommandRequest        
        Switch ($CommandType){
            "SET_VOLUME" {
                $RequestBody.Payload = @{"volume" = $PSBoundParameters["Payload"]}
            }
            Default {}
        }            
        $RequestBody.CommandType = $CommandType
    }
    Process {
        $DeviceID | ForEach-Object {
            $verbString = "Sending command $commandType to ChromeOS device $_"
            write-host $_
            try {
                    
                Write-Verbose $verbString                 
                $Request = $Service.Customer.Devices.Chromeos.IssueCommand($RequestBody, $CustomerID, $_)
                Switch ($CommandType){
                    "REBOOT" {
                        if ($PSCmdlet.ShouldProcess($DeviceID, 'Reboot the device.')){
                            $Result = $Request.Execute()
                        }
                    }
                    "WIPE_USERS" {
                        if ($PSCmdlet.ShouldProcess($DeviceID, 'Wipe all users profiles from the device.')){
                            $Result = $Request.Execute()
                        }
                    }
                    "REMOTE_POWERWASH" {
                        if ($PSCmdlet.ShouldProcess($DeviceID, 'Powerwash the device.')){
                            $Result = $Request.Execute()
                        }
                    }
                    Default {
                        $Result = $Request.Execute()
                    }
                }

                If ($null -ne $Result){
                    $Result | Add-Member -MemberType NoteProperty -Name DeviceID -Value $_
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
}
