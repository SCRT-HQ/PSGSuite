function Update-GSOrganizationalUnit {
    <#
    .SYNOPSIS
    Updates an OrgUnit
    
    .DESCRIPTION
    Updates an Organizational Unit
    
    .PARAMETER OrgUnitID
    The unique Id of the OrgUnit to update
    
    .PARAMETER OrgUnitPath
    The path of the OrgUnit to update
    
    .PARAMETER Name
    The new name for the OrgUnit
    
    .PARAMETER ParentOrgUnitId
    The new Parent ID for the OrgUnit
    
    .PARAMETER ParentOrgUnitPath
    The path of the new Parent for the OrgUnit
    
    .PARAMETER Description
    The new description for the OrgUnit
    
    .PARAMETER BlockInheritance
    Determines if a sub-organizational unit can inherit the settings of the parent organization. The default value is false, meaning a sub-organizational unit inherits the settings of the nearest parent organizational unit. For more information on inheritance and users in an organization structure, see the administration help center: http://support.google.com/a/bin/answer.py?hl=en&answer=182442&topic=1227584&ctx=topic
    
    .EXAMPLE
    Update-GSOrganizationalUnit -OrgUnitPath "/Testing" -Name "Testing More" -Description "Doing some more testing"

    Updates the OrgUnit '/Testing' with a new name "Testing More" and new description "Doing some more testing"
    #>
    [cmdletbinding(DefaultParameterSetName = "Id")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true,ParameterSetName = "Id")]
        [ValidateNotNullOrEmpty()]
        [String]
        $OrgUnitID,
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true,ParameterSetName = "Path")]
        [ValidateNotNullOrEmpty()]
        [String]
        $OrgUnitPath,
        [parameter(Mandatory = $false)]
        [String]
        $Name,
        [parameter(Mandatory = $false)]
        [string]
        $ParentOrgUnitId,
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
            $body = switch ($PSCmdlet.ParameterSetName) {
                Path {
                    Get-GSOrganizationalUnit -OrgUnitPath $OrgUnitPath -Verbose:$false
                }
                Id {
                    Get-GSOrganizationalUnit -OrgUnitPath $OrgUnitID -Verbose:$false
                }
            }
            if ($ParentOrgUnitPath) {
                $body.ParentOrgUnitId = $(Get-GSOrganizationalUnit -OrgUnitPath $ParentOrgUnitPath -Verbose:$false | Select-Object -ExpandProperty OrgUnitID)
            }
            elseif ($ParentOrgUnitId) {
                $body.ParentOrgUnitPath = $(Get-GSOrganizationalUnit -OrgUnitPath $ParentOrgUnitId -Verbose:$false | Select-Object -ExpandProperty OrgUnitPath)
            }
            Write-Verbose "Updating OrgUnit '$OrgUnitPath'"
            foreach ($prop in $PSBoundParameters.Keys | Where-Object {$body.PSObject.Properties.Name -contains $_ -and $_ -ne 'OrgUnitPath'}) {
                $body.$prop = $PSBoundParameters[$prop]
            }
            $trimPath = $body.OrgUnitPath.TrimStart('/')
            $request = $service.Orgunits.Patch($body,$Script:PSGSuite.CustomerId,([Google.Apis.Util.Repeatable[String]]::new([String[]]$trimPath)))
            $request.Execute()
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}