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
    
    .EXAMPLE
    Get-GSAdminRole

    Gets the list of Admin Roles
    
    .EXAMPLE
    Get-GSAdminRole -RoleId 9191482342768644,9191482342768642

    Gets the admin roles matching the provided Ids
    #>
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
        $PageSize
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
                    if ($PSBoundParameters.Keys -contains 'PageSize') {
                        $request.MaxResults = $PSBoundParameters['PageSize']
                    }
                    [int]$i = 1
                    do {
                        $result = $request.Execute()
                        $result.Items
                        $request.PageToken = $result.NextPageToken
                        [int]$retrieved = ($i + $result.Items.Count) - 1
                        Write-Verbose "Retrieved $retrieved roles..."
                        [int]$i = $i + $result.Items.Count
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