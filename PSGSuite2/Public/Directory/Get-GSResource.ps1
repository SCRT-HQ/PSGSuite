function Get-GSResource {
    <#
    .SYNOPSIS
    Gets Calendar Resources (Calendars, Buildings & Features supported)
    
    .DESCRIPTION
    Gets Calendar Resources (Calendars, Buildings & Features supported)
    
    .PARAMETER Id
    If Id is provided, gets the Resource by Id
    
    .PARAMETER Resource
    The Resource Type to List

    Available choices are:
    * "Calendars": resource calendars (legacy and new - i.e. conference rooms)
    * "Buildings": new Building Resources (i.e. "Building A" or "North Campus")
    * "Features": new Feature Resources (i.e. "Video Conferencing" or "Projector")
    
    .PARAMETER Filter
    String query used to filter results. Should be of the form "field operator value" where field can be any of supported fields and operators can be any of supported operations. Operators include '=' for exact match and ':' for prefix match or HAS match where applicable. For prefix match, the value should always be followed by a *. Supported fields include generatedResourceName, name, buildingId, featureInstances.feature.name. For example buildingId=US-NYC-9TH AND featureInstances.feature.name:Phone.

    PowerShell filter syntax here is supported as "best effort". Please use Google's filter operators and syntax to ensure best results
    
    .PARAMETER OrderBy
    Field(s) to sort results by in either ascending or descending order. Supported fields include resourceId, resourceName, capacity, buildingId, and floorName.
    
    .PARAMETER PageSize
    Page size of the result set
    
    .EXAMPLE
    Get-GSResource -Resource Buildings

    Gets the full list of Buildings Resources
    #>
    [CmdletBinding(DefaultParameterSetName = "List")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true,ParameterSetName = "Get")]
        [String[]]
        $Id,
        [parameter(Mandatory = $false)]
        [ValidateSet('Calendars','Buildings','Features')]
        [String]
        $Resource = 'Calendars',
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Alias('Query')]
        [String[]]
        $Filter,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [String[]]
        $OrderBy,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [ValidateScript( {[int]$_ -le 500 -and [int]$_ -ge 1})]
        [Alias("MaxResults")]
        [Int]
        $PageSize = "500"
    )
    Begin {
        if ($PSCmdlet.ParameterSetName -eq 'Get') {
            $serviceParams = @{
                Scope       = 'https://www.googleapis.com/auth/admin.directory.resource.calendar'
                ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
            }
            $service = New-GoogleService @serviceParams
        }
    }
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Get {
                    foreach ($I in $Id) {
                        Write-Verbose "Getting Resource $Resource Id '$I'"
                        $request = $service.Resources.$Resource.Get($(if($Script:PSGSuite.CustomerID){$Script:PSGSuite.CustomerID}else{'my_customer'}),$I)
                        $request.Execute() | Select-Object @{N = 'Resource';E = {$Resource}},*
                    }
                }
                List {
                    Get-GSResourceListPrivate @PSBoundParameters
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}