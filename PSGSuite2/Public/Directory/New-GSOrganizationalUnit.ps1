function New-GSOrganizationalUnit {
    <#
.Synopsis
   Creates a new Organizational Unit in Google Apps
.DESCRIPTION
   Creates a new Organizational Unit in Google Apps.
.EXAMPLE
   New-GSOrganizationalUnit -Name "Test Org" -ParentOrgUnitPath "/Testing" -Description "This is a test OrgUnit"
#>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true)]
        [String]
        $Name,
        [parameter(Mandatory = $false)]
        [string]
        $ParentOrgUnitPath,
        [parameter(Mandatory = $false)]
        [String]
        $Description,
        [parameter(Mandatory = $false)]
        [Switch]
        $BlockInheritance
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
            Write-Verbose "Creating OrgUnit '$Name'"
            $body = [Google.Apis.Admin.Directory.directory_v1.Data.OrgUnit]::new()
            foreach ($prop in $PSBoundParameters.Keys | Where-Object {$body.PSObject.Properties.Name -contains $_}) {
                switch ($prop) {
                    Default {
                        $body.$prop = $PSBoundParameters[$prop]
                    }
                }
            }
            $request = $service.Orgunits.Insert($body,$Script:PSGSuite.CustomerId)
            $request.Execute()
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}