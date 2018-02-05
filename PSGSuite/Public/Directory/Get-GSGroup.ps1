function Get-GSGroup {
    <#
    .SYNOPSIS
    Gets the specified group's information. Returns the full group list if -Group is excluded
    
    .DESCRIPTION
    Gets the specified group's information. Returns the full group list if -Group is excluded. Designed for parity with Get-ADGroup (although Google's API is unable to 'Filter' for groups)
    
    .PARAMETER Group
    The list of groups you would like to retrieve info for. If excluded, returns the group list instead
    
    .PARAMETER Fields
    The fields to return in the response
    
    .PARAMETER Where_IsAMember
    Include a user email here to get the list of groups that user is a member of
    
    .PARAMETER PageSize
    Page size of the result set

    Defaults to 200
    
    .EXAMPLE
    Get-GSGroup -Where_IsAMember "joe@domain.com"

    Gets the list of groups that joe@domain.com is a member of
    #>
    [cmdletbinding(DefaultParameterSetName = "List")]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true,ParameterSetName = "Get")]
        [Alias("Email")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Group,
        [parameter(Mandatory = $false)]
        [String[]]
        $Fields,
        [parameter(Mandatory=$false,ParameterSetName = "List")]
        [String]
        $Where_IsAMember,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [ValidateRange(1,200)]
        [Alias("MaxResults")]
        [Int]
        $PageSize = "200"
    )
    Begin {
        if ($PSCmdlet.ParameterSetName -eq 'Get') {
            $serviceParams = @{
                Scope       = 'https://www.googleapis.com/auth/admin.directory.group'
                ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
            }
            $service = New-GoogleService @serviceParams
        }
    }
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Get {
                    foreach ($G in $Group) {
                        if ($G -notlike "*@*.*") {
                            $G = "$($G)@$($Script:PSGSuite.Domain)"
                        }
                        Write-Verbose "Getting group '$G'"
                        $request = $service.Groups.Get($G)
                        if ($Fields) {
                            $request.Fields = "$($Fields -join ",")"
                        }
                        $request.Execute() | Select-Object @{N = "Group";E = {$_.Email}},*
                    }
                }
                List {
                    Get-GSGroupListPrivate @PSBoundParameters
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}