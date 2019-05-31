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

    Available values are:
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

    .PARAMETER Limit
    The maximum amount of results you want returned. Exclude or set to 0 to return all results

    .EXAMPLE
    Get-GSResource -Resource Buildings

    Gets the full list of Buildings Resources
    #>
    [CmdletBinding(DefaultParameterSetName = "List")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true,ParameterSetName = "Get")]
        [String[]]
        $Id,
        [parameter(Mandatory = $false,Position = 1)]
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
        [ValidateRange(1,500)]
        [Alias("MaxResults")]
        [Int]
        $PageSize = 500,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Alias('First')]
        [Int]
        $Limit = 0
    )
    Begin {
        if ($MyInvocation.InvocationName -eq 'Get-GSCalendarResourceList') {
            $Resource = 'Calendars'
        }
        $propHash = @{
            Calendars = 'Items'
            Buildings = 'BuildingsValue'
            Features  = 'FeaturesValue'
        }
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.resource.calendar'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
        $customerId = if ($Script:PSGSuite.CustomerID) {
            $Script:PSGSuite.CustomerID
        }
        else {
            'my_customer'
        }
    }
    Process {
        switch ($PSCmdlet.ParameterSetName) {
            Get {
                foreach ($I in $Id) {
                    try {
                        Write-Verbose "Getting Resource $Resource Id '$I'"
                        $request = $service.Resources.$Resource.Get($customerId,$I)
                        $request.Execute() | Add-Member -MemberType NoteProperty -Name 'Id' -Value $I -PassThru | Add-Member -MemberType NoteProperty -Name 'Resource' -Value $Resource -PassThru | Add-Member -MemberType ScriptMethod -Name ToString -Value { $this.Id } -PassThru -Force
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
            List {
                try {
                    $request = $service.Resources.$Resource.List($customerId)
                    if ($Limit -gt 0 -and $PageSize -gt $Limit) {
                        Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with first page" -f $PageSize,$Limit)
                        $PageSize = $Limit
                    }
                    $request.MaxResults = $PageSize
                    if ($Resource -eq 'Calendars') {
                        if ($OrderBy) {
                            $request.OrderBy = "$($OrderBy -join ", ")"
                        }
                        if ($Filter) {
                            if ($Filter -eq '*') {
                                $Filter = ""
                            }
                            else {
                                $Filter = "$($Filter -join " ")"
                            }
                            $Filter = $Filter -replace " -eq ","=" -replace " -like ",":" -replace " -match ",":" -replace " -contains ",":" -creplace "'True'","True" -creplace "'False'","False"
                            $request.Query = $Filter.Trim()
                            Write-Verbose "Getting Resource $Resource matching filter: `"$($Filter.Trim())`""
                        }
                        else {
                            Write-Verbose "Getting all Resource $Resource"
                        }
                    }
                    else {
                        Write-Verbose "Getting all Resource $Resource"
                    }
                    [int]$i = 1
                    $overLimit = $false
                    do {
                        $result = $request.Execute()
                        $result.$($propHash[$Resource]) | ForEach-Object {
                            $obj = $_
                            $_Id = switch ($Resource) {
                                Calendars {
                                    $obj.ResourceId
                                }
                                Buildings {
                                    $obj.BuildingId
                                }
                                Features {
                                    $obj.Name
                                }
                            }
                            $_ | Add-Member -MemberType NoteProperty -Name 'Id' -Value $_Id -PassThru | Add-Member -MemberType NoteProperty -Name 'Resource' -Value $Resource -PassThru | Add-Member -MemberType ScriptMethod -Name ToString -Value { $this.Id } -PassThru -Force
                        }
                        if ($result.NextPageToken) {
                            $request.PageToken = $result.NextPageToken
                        }
                        [int]$retrieved = ($i + $result.$($propHash[$Resource]).Count) - 1
                        Write-Verbose "Retrieved $retrieved resources..."
                        if ($Limit -gt 0 -and $retrieved -eq $Limit) {
                            Write-Verbose "Limit reached: $Limit"
                            $overLimit = $true
                        }
                        elseif ($Limit -gt 0 -and ($retrieved + $PageSize) -gt $Limit) {
                            $newPS = $Limit - $retrieved
                            Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with next page" -f $PageSize,$newPS)
                            $request.MaxResults = $newPS
                        }
                        [int]$i = $i + $result.$($propHash[$Resource]).Count
                    }
                    until ($overLimit -or !$result.NextPageToken)
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
    }
}
