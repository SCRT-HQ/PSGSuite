function Get-GSAdminRole {
    <#
    .SYNOPSIS
    Gets a specific Admin Role or the list of Admin Roles

    .DESCRIPTION
    Gets a specific Admin Role or the list of Admin Roles

    .PARAMETER RoleId
    The RoleId(s) you would like to retrieve info for.

    If left blank, returns the full list of Roles

    .PARAMETER PageSize
    Page size of the result set

    .PARAMETER Limit
    The maximum amount of results you want returned. Exclude or set to 0 to return all results

    .EXAMPLE
    Get-GSAdminRole

    Gets the list of Admin Roles

    .EXAMPLE
    Get-GSAdminRole -RoleId 9191482342768644,9191482342768642

    Gets the admin roles matching the provided Ids
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.Role')]
    [cmdletbinding(DefaultParameterSetName = "List")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ParameterSetName = "Get")]
        [int64[]]
        $RoleId,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [ValidateRange(1,100)]
        [Alias("MaxResults")]
        [Int]
        $PageSize = 100,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Alias('First')]
        [Int]
        $Limit = 0
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.rolemanagement'
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
                foreach ($Role in $RoleId) {
                    try {
                        Write-Verbose "Getting Admin Role '$Role'"
                        $request = $service.Roles.Get($customerId,$Role)
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
            List {
                try {
                    Write-Verbose "Getting Admin Role List"
                    $request = $service.Roles.List($customerId)
                    if ($Limit -gt 0 -and $PageSize -gt $Limit) {
                        Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with first page" -f $PageSize,$Limit)
                        $PageSize = $Limit
                    }
                    $request.MaxResults = $PageSize
                    [int]$i = 1
                    $overLimit = $false
                    do {
                        $result = $request.Execute()
                        $result.Items
                        $request.PageToken = $result.NextPageToken
                        [int]$retrieved = ($i + $result.Items.Count) - 1
                        Write-Verbose "Retrieved $retrieved roles..."
                        if ($Limit -gt 0 -and $retrieved -eq $Limit) {
                            Write-Verbose "Limit reached: $Limit"
                            $overLimit = $true
                        }
                        elseif ($Limit -gt 0 -and ($retrieved + $PageSize) -gt $Limit) {
                            $newPS = $Limit - $retrieved
                            Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with next page" -f $PageSize,$newPS)
                            $request.MaxResults = $newPS
                        }
                        [int]$i = $i + $result.Items.Count
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
