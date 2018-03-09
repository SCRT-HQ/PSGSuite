function New-GSOrganizationalUnit {
    <#
    .SYNOPSIS
    Creates a new OrgUnit
    
    .DESCRIPTION
    Creates a new Organizational Unit
    
    .PARAMETER Name
    The name of the new OrgUnit
    
    .PARAMETER ParentOrgUnitPath
    The path of the parent OrgUnit

    Defaults to "/" (the root OrgUnit)

    .PARAMETER ParentOrgUnitId
    The unique ID of the parent organizational unit. 
    
    .PARAMETER Description
    Description of the organizational unit.
    
    .PARAMETER BlockInheritance
    Determines if a sub-organizational unit can inherit the settings of the parent organization. The default value is false, meaning a sub-organizational unit inherits the settings of the nearest parent organizational unit. For more information on inheritance and users in an organization structure, see the administration help center: http://support.google.com/a/bin/answer.py?hl=en&answer=182442&topic=1227584&ctx=topic
    
    .EXAMPLE
    New-GSOrganizationalUnit -Name "Test Org" -ParentOrgUnitPath "/Testing" -Description "This is a test OrgUnit"
    
    Creates a new OrgUnit named "Test Org" underneath the existing org unit path "/Testing" with the description "This is a test OrgUnit"
    #>
    [cmdletbinding(DefaultParameterSetName = 'ParentOrgUnitPath')]
    Param
    (
        [parameter(Mandatory = $true)]
        [String]
        $Name,
        [parameter(Mandatory = $false,ParameterSetName = 'ParentOrgUnitPath')]
        [string]
        $ParentOrgUnitPath,
        [parameter(Mandatory = $false,ParameterSetName = 'ParentOrgUnitId')]
        [string]
        $ParentOrgUnitId,
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
        if ($PSBoundParameters.Keys -notcontains 'ParentOrgUnitPath' -and $PSCmdlet.ParameterSetName -eq 'ParentOrgUnitPath') {
            $PSBoundParameters['ParentOrgUnitPath'] = '/'
        }
    }
    Process {
        try {
            Write-Verbose "Creating OrgUnit '$Name'"
            $body = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.OrgUnit'
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
            if ($ErrorActionPreference -eq 'Stop') {
                $PSCmdlet.ThrowTerminatingError($_)
            }
            else {
                Write-Error $_
            }
        }
    }
}