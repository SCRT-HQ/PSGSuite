function Get-GSGroup {
    <#
    .SYNOPSIS
    Gets the specified group's information. Returns the full group list if -Group is excluded

    .DESCRIPTION
    Gets the specified group's information. Returns the full group list if -Group is excluded. Designed for parity with Get-ADGroup (although Google's API is unable to 'Filter' for groups)

    .PARAMETER Group
    The list of groups you would like to retrieve info for. If excluded, returns the group list instead

    .PARAMETER Filter
    Query string search. Complete documentation is at https://developers.google.com/admin-sdk/directory/v1/guides/search-groups

    .PARAMETER Where_IsAMember
    Include a user email here to get the list of groups that user is a member of

    .PARAMETER Domain
    The domain name. Use this field to get fields from only one domain. To return groups for all domains you own, exclude this parameter

    .PARAMETER Fields
    The fields to return in the response

    .PARAMETER PageSize
    Page size of the result set

    Defaults to 200

    .EXAMPLE
    Get-GSGroup -Where_IsAMember "joe@domain.com"

    Gets the list of groups that joe@domain.com is a member of

    .EXAMPLE
    Get-GSGroup -Domain mysubdomain.org

    Gets the list of groups only for the 'mysubdomain.org' domain.

    .EXAMPLE
    Get-GSGroup -Filter "email:support*"

    Gets all the groups with emails beginning with 'support'

    .EXAMPLE
    Get-GSGroup -Filter "name -eq 'IT HelpDesk'"

    Gets the IT HelpDesk group by name using PowerShell syntax. PowerShell syntax is supported as a best effort, please refer to the Group Search documentation from Google for exact syntax.
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.Group')]
    [cmdletbinding(DefaultParameterSetName = "ListFilter")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true,ParameterSetName = "Get")]
        [Alias("Email")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Group,
        [parameter(Mandatory = $false,ParameterSetName = "ListFilter")]
        [Alias('Query')]
        [string]
        $Filter,
        [parameter(Mandatory = $false,ParameterSetName = "ListWhereMember")]
        [Alias('UserKey')]
        [String]
        $Where_IsAMember,
        [parameter(Mandatory = $false,ParameterSetName = "ListFilter")]
        [string]
        $Domain,
        [parameter(Mandatory = $false,ParameterSetName = "Get")]
        [String[]]
        $Fields,
        [parameter(Mandatory = $false,ParameterSetName = "ListFilter")]
        [parameter(Mandatory = $false,ParameterSetName = "ListWhereMember")]
        [ValidateRange(1,200)]
        [Alias("MaxResults")]
        [Int]
        $PageSize = "200"
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.group'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        switch -Regex ($PSCmdlet.ParameterSetName) {
            Get {
                foreach ($G in $Group) {
                    try {
                        Resolve-Email ([ref]$G)
                        Write-Verbose "Getting group '$G'"
                        $request = $service.Groups.Get($G)
                        if ($Fields) {
                            $request.Fields = "$($Fields -join ",")"
                        }
                        $request.Execute() | Add-Member -MemberType NoteProperty -Name 'Group' -Value $G -PassThru
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
            'List.*' {
                $verbString = "Getting all G Suite Groups"
                try {
                    $request = $service.Groups.List()
                    if ($PSBoundParameters.Keys -contains 'Where_IsAMember') {
                        Resolve-Email ([ref]$Where_IsAMember)
                        $verbString += " where '$Where_IsAMember' is a member"
                        $request.UserKey = $Where_IsAMember
                    }
                    elseif ($PSBoundParameters.Keys -contains 'Filter') {
                        if ($Filter -eq '*') {
                            $Filter = ""
                        }
                        else {
                            $Filter = "$($Filter -join " ")"
                        }
                        $Filter = $Filter -replace " -eq ","=" -replace " -like ",":" -replace " -match ",":" -replace " -contains ",":" -creplace "'True'","True" -creplace "'False'","False"
                        if (-not [String]::IsNullOrEmpty($Filter.Trim())) {
                            $verbString += " matching query '$($Filter.Trim())'"
                            $request.Query = $Filter.Trim()
                        }
                    }
                    if ($PSBoundParameters.Keys -notcontains 'Where_IsAMember') {
                        if ($PSBoundParameters.Keys -contains 'Domain') {
                            $verbString += " for domain '$Domain'"
                            $request.Domain = $Domain
                        }
                        elseif ( -not [String]::IsNullOrEmpty($Script:PSGSuite.CustomerID)) {
                            $verbString += " for customer '$($Script:PSGSuite.CustomerID)'"
                            $request.Customer = $Script:PSGSuite.CustomerID
                        }
                        else {
                            $verbString += " for customer 'my_customer'"
                            $request.Customer = "my_customer"
                        }
                    }
                    if ($PageSize) {
                        $request.MaxResults = $PageSize
                    }
                    Write-Verbose $verbString
                    [int]$i = 1
                    do {
                        $result = $request.Execute()
                        if ($null -ne $result.GroupsValue) {
                            $result.GroupsValue | Add-Member -MemberType ScriptMethod -Name ToString -Value {$this.Email} -PassThru -Force
                        }
                        $request.PageToken = $result.NextPageToken
                        [int]$retrieved = ($i + $result.GroupsValue.Count) - 1
                        Write-Verbose "Retrieved $retrieved groups..."
                        [int]$i = $i + $result.GroupsValue.Count
                    }
                    until (!$result.NextPageToken)
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
