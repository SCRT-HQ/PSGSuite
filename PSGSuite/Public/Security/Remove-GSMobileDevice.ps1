function Remove-GSMobileDevice {
    <#
    .SYNOPSIS
    Removes a mobile device from Device Management
    
    .DESCRIPTION
    Removes a mobile device from Device Management
    
    .PARAMETER ResourceID
    The unique Id of the mobile device you would like to remove
    
    .EXAMPLE
    Remove-GSMobileDevice -ResourceId 'AFiQxQ8Qgd-rouSmcd2UnuvhYV__WXdacTgJhPEA1QoQJrK1hYbKJXm-8JFlhZOjBF4aVbhleS2FVQk5lI069K2GULpteTlLVpKLJFSLSL'
    
    Removes the mobile device with the specified Id
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $ResourceId
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.device.mobile'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            foreach ($R in $DeviceId) {
                if ($PSCmdlet.ShouldProcess("Removing Mobile Device '$R'")) {
                    Write-Verbose "Removing Mobile Device '$R'"
                    $request = $service.Mobiledevices.Delete($Script:PSGSuite.CustomerID,$R)
                    $request.Execute()
                    Write-Verbose "Mobile Device '$R' has been successfully removed"
                }
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