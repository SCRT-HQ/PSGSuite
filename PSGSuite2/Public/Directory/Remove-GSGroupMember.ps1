function Remove-GSGroupMember {
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('GroupEmail','Group','Email')]
        [String]
        $Identity,
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true,Position = 1)]
        [Alias("PrimaryEmail","UserKey","Mail","User","UserEmail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Member
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
            if ($Identity -notlike "*@*.*") {
                $Identity = "$($Identity)@$($Script:PSGSuite.Domain)"
            }
            foreach ($G in $Member) {
                if ($G -notlike "*@*.*") {
                    $G = "$($G)@$($Script:PSGSuite.Domain)"
                }
                if ($PSCmdlet.ShouldProcess("Removing member '$G' from group '$Identity'")) {
                    Write-Verbose "Removing member '$G' from group '$Identity'"
                    $request = $service.Members.Delete($Identity,$G)
                    $request.Execute()
                    Write-Verbose "Member '$G' has been successfully removed"
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}