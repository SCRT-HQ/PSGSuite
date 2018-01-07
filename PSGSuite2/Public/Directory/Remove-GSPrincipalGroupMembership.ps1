function Remove-GSPrincipalGroupMembership {
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail","User","UserEmail")]
        [String]
        $Identity,
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true,Position = 1)]
        [Alias('GroupEmail','Group','Email')]
        [String[]]
        $MemberOf
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
            foreach ($G in $MemberOf) {
                if ($G -notlike "*@*.*") {
                    $G = "$($G)@$($Script:PSGSuite.Domain)"
                }
                if ($PSCmdlet.ShouldProcess("Removing member '$Identity' from group '$G'")) {
                    Write-Verbose "Removing member '$Identity' from group '$G'"
                    $request = $service.Members.Delete($G,$Identity)
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