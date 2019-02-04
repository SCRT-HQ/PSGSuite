function Move-GSChromeOSDevice {
    <#
    .SYNOPSIS
    Moves a ChromeOS device to a new OrgUnit

    .DESCRIPTION
    Moves a ChromeOS device to a new OrgUnit

    .PARAMETER ResourceId
    The unique ID of the device you would like to move.

    .PARAMETER OrgUnitPath
    Full path of the target organizational unit or its ID

    .EXAMPLE
    Move-GSChromeOSDevice -ResourceId 'AFiQxQ8Qgd-rouSmcd2UnuvhYV__WXdacTgJhPEA1QoQJrK1hYbKJXm-8JFlhZOjBF4aVbhleS2FVQk5lI069K2GULpteTlLVpKLJFSLSL' -OrgUnitPath '/Corp'

    Moves the ChromeOS device specified to the /Corp OrgUnit
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.ChromeOSDevice')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias('Id','Device','DeviceId')]
        [String[]]
        $ResourceId,
        [parameter(Mandatory = $true,Position = 1)]
        [String]
        $OrgUnitPath
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.device.chromeos'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams -Verbose:$false
        $customerId = if ($Script:PSGSuite.CustomerID) {
            $Script:PSGSuite.CustomerID
        }
        else {
            "my_customer"
        }
        $toMove = New-Object 'System.Collections.Generic.List[string]'
    }
    Process {
        $ResourceId | ForEach-Object {
            $toMove.Add($_)
        }
    }
    End {
        try {
            Write-Verbose "Moving the following Chrome OS Devices to OrgUnitPath '$OrgUnitPath':`n    - $($toMove -join "`n    - ")"
            $body = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.ChromeOsMoveDevicesToOu' -Property @{
                DeviceIds = $toMove
            }
            $request = $service.Chromeosdevices.MoveDevicesToOu($body,$customerId,$OrgUnitPath)
            $request.Execute()
            Write-Verbose "The Chrome OS devices were successfully moved."
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
