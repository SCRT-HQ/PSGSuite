function Remove-GSMobileDevice {
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $ResourceID
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
            foreach ($R in $ResourceID) {
                if ($PSCmdlet.ShouldProcess("Removing Mobile Device '$R'")) {
                    Write-Verbose "Removing Mobile Device '$R'"
                    $request = $service.Mobiledevices.Delete($Script:PSGSuite.CustomerID,$R)
                    $request.Execute()
                    Write-Verbose "Mobile Device '$R' has been successfully removed"
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}