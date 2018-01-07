function Remove-GSGroup {
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('GroupEmail','Group','Email')]
        [String[]]
        $Identity
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.group'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            foreach ($G in $Identity) {
                if ($G -notlike "*@*.*") {
                    $G = "$($G)@$($Script:PSGSuite.Domain)"
                }
                if ($PSCmdlet.ShouldProcess("Removing group '$G'")) {
                    Write-Verbose "Removing group '$G'"
                    $request = $service.Groups.Delete($G)
                    $request.Execute()
                    Write-Verbose "Group '$G' has been successfully removed"
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}