function Get-GSAdminRoleAssignment {
    <#
    .SYNOPSIS
    Gets a specific Admin Role Assignments or the list of Admin Role Assignments for a given role

    .DESCRIPTION
    Gets a specific Admin Role Assignments or the list of Admin Role Assignments for a given role

    .PARAMETER RoleAssignmentId
    The RoleAssignmentId(s) you would like to retrieve info for.

    If left blank, returns the full list of Role Assignments

    .PARAMETER UserKey
    The UserKey(s) you would like to retrieve Role Assignments for. This can be a user's email or their unique UserId

    If left blank, returns the full list of Role Assignments

    .PARAMETER RoleId
    The RoleId(s) you would like to retrieve Role Assignments for.

    If left blank, returns the full list of Role Assignments

    .PARAMETER PageSize
    Page size of the result set

    .PARAMETER Limit
    The maximum amount of results you want returned. Exclude or set to 0 to return all results

    .EXAMPLE
    Get-GSAdminRoleAssignment

    Gets the list of Admin Role Assignments

    .EXAMPLE
    Get-GSAdminRoleAssignment -RoleId 9191482342768644,9191482342768642

    Gets the Admin Role Assignments matching the provided RoleIds
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.RoleAssignment')]
    [cmdletbinding(DefaultParameterSetName = "ListUserKey")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ParameterSetName = "Get")]
        [String[]]
        $RoleAssignmentId,
        [parameter(Mandatory = $false,ParameterSetName = "ListUserKey")]
        [string[]]
        $UserKey,
        [parameter(Mandatory = $false,ParameterSetName = "ListRoleId")]
        [string[]]
        $RoleId,
        [parameter(Mandatory = $false,ParameterSetName = "ListUserKey")]
        [parameter(Mandatory = $false,ParameterSetName = "ListRoleId")]
        [ValidateRange(1,100)]
        [Alias("MaxResults")]
        [Int]
        $PageSize = 100,
        [parameter(Mandatory = $false,ParameterSetName = "ListUserKey")]
        [parameter(Mandatory = $false,ParameterSetName = "ListRoleId")]
        [Alias('First')]
        [Int]
        $Limit = 0
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.rolemanagement.readonly'
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
                foreach ($Role in $RoleAssignmentId) {
                    try {
                        Write-Verbose "Getting Admin Role Assignment '$Role'"
                        $request = $service.RoleAssignments.Get($customerId,$Role)
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
            Default {
                [int]$i = 1
                $overLimit = $false
                Write-Verbose "Getting Admin Role Assignment List"
                $baseRequest = $service.RoleAssignments.List($customerId)
                if ($Limit -gt 0 -and $PageSize -gt $Limit) {
                    Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with first page" -f $PageSize,$Limit)
                    $PageSize = $Limit
                }
                $baseRequest.MaxResults = $PageSize
                if ($PSBoundParameters.Keys -contains 'RoleId' -or $PSBoundParameters.Keys -contains 'UserKey') {
                    switch ($PSBoundParameters.Keys) {
                        RoleId {
                            foreach ($Role in $RoleId) {
                                if (-not $overLimit) {
                                    try {
                                        $request = $baseRequest
                                        $request.RoleId = $Role
                                        do {
                                            $result = $request.Execute()
                                            $result.Items | Add-Member -MemberType NoteProperty -Name 'Filter' -Value ([PSCustomObject]@{RoleId = $Role}) -PassThru
                                            $request.PageToken = $result.NextPageToken
                                            [int]$retrieved = ($i + $result.Items.Count) - 1
                                            Write-Verbose "Retrieved $retrieved role assignments..."
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
                        UserKey {
                            foreach ($User in $UserKey) {
                                try {
                                    $request = $baseRequest
                                    $uKey = try {
                                        [int64]$User
                                    }
                                    catch {
                                        if ($User -ceq 'me') {
                                            $User = $Script:PSGSuite.AdminEmail
                                        }
                                        elseif ($User -notlike "*@*.*") {
                                            $User = "$($User)@$($Script:PSGSuite.Domain)"
                                        }
                                        (Get-GSUser -User $User -Verbose:$false).Id
                                    }
                                    $request.UserKey = $uKey
                                    do {
                                        $result = $request.Execute()
                                        $result.Items | Add-Member -MemberType NoteProperty -Name 'Filter' -Value ([PSCustomObject]@{UserKey = $User}) -PassThru
                                        $request.PageToken = $result.NextPageToken
                                        [int]$retrieved = ($i + $result.Items.Count) - 1
                                        Write-Verbose "Retrieved $retrieved role assignments..."
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
                else {
                    try {
                        $request = $baseRequest
                        do {
                            $result = $request.Execute()
                            $result.Items
                            $request.PageToken = $result.NextPageToken
                            [int]$retrieved = ($i + $result.Items.Count) - 1
                            Write-Verbose "Retrieved $retrieved role assignments..."
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
}
