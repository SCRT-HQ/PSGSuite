function Remove-GSOrganizationalUnit {
    <#
    .Synopsis
       Removes an existing Google Organizational Unit
    .DESCRIPTION
       Removes an existing Google Organizational Unit
    .EXAMPLE
       Remove-GSUser -OrgUnitPath john.smith@domain.com -WhatIf
    .EXAMPLE
       Remove-GSUser -User john.smith@domain.com -Confirm:$false
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [String[]]
        $OrgUnitPath
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.orgunit'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            foreach ($O in $OrgUnitPath) {
                if ($PSCmdlet.ShouldProcess("Deleting OrgUnit at Path '$O'")) {
                    Write-Verbose "Deleting OrgUnit at Path '$O'"
                    $O = $O.TrimStart('/')
                    $request = $service.Orgunits.Delete($Script:PSGSuite.CustomerId,([Google.Apis.Util.Repeatable[String]]::new([String[]]$O)))
                    $request.Execute()
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}