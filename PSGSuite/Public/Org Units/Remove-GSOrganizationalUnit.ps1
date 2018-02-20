function Remove-GSOrganizationalUnit {
    <#
    .SYNOPSIS
    Removes an OrgUnit
    
    .DESCRIPTION
    Removes an Organization Unit
    
    .PARAMETER OrgUnitPath
    The path of the OrgUnit you would like to Remove-GSOrganizationalUnit
    
    .EXAMPLE
    Remove-GSOrganizationalUnit -OrgUnitPath "/Testing"

    Removes the OrgUnit "/Testing" on confirmation
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
            if ($ErrorActionPreference -eq 'Stop') {
                $PSCmdlet.ThrowTerminatingError($_)
            }
            else {
                Write-Error $_
            }
        }
    }
}