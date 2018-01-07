function Get-GSOrganizationalUnit {
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0)]
        [String[]]
        $OrgUnitPath
    )
    Begin {
        if ($PSBoundParameters.Keys -contains 'OrgUnitPath' -and $OrgUnitPath -ne "/") {
            $serviceParams = @{
                Scope       = 'https://www.googleapis.com/auth/admin.directory.orgunit'
                ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
            }
            $service = New-GoogleService @serviceParams
        }
    }
    Process {
        try {
            if ($PSBoundParameters.Keys -contains 'OrgUnitPath' -and $OrgUnitPath -ne "/") {
                foreach ($O in $OrgUnitPath) {
                    Write-Verbose "Getting Organizational Unit '$O'"
                    $O = $O.TrimStart('/')
                    $request = $service.Orgunits.Get($Script:PSGSuite.CustomerId,([Google.Apis.Util.Repeatable[String]]::new([String[]]$O)))
                    $request.Execute()
                }
            }
            else {
                if ($OrgUnitPath -eq "/") {
                    $topId = Get-GSOrganizationalUnitList -OrgUnitPath "/" -Type Children -Verbose:$false | Where-Object {$_.ParentOrgUnitPath -eq "/"} | Select-Object -ExpandProperty ParentOrgUnitId -Unique
                    Get-GSOrganizationalUnit -OrgUnitPath $topId
                }
                else {
                    Get-GSOrganizationalUnitList
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}