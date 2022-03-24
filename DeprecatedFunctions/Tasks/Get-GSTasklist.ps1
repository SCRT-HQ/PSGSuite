function Get-GSTasklist {
    <#
    .SYNOPSIS
    Gets a specific Tasklist or the list of Tasklists

    .DESCRIPTION
    Gets a specific Tasklist or the list of Tasklists

    .PARAMETER User
    The User who owns the Tasklist.

    Defaults to the AdminUser's email.

    .PARAMETER Tasklist
    The unique Id of the Tasklist.

    If left blank, gets the full list of Tasklists

    .PARAMETER PageSize
    Page size of the result set

    .PARAMETER Limit
    The maximum amount of results you want returned. Exclude or set to 0 to return all results

    .EXAMPLE
    Get-GSTasklist

    Gets the list of Tasklists owned by the AdminEmail user

    .EXAMPLE
    Get-GSTasklist -Tasklist MTUzNTU0MDYscM0NjKDMTIyNjQ6MDow -User john@domain.com

    Gets the Tasklist matching the provided Id owned by John
    #>
    [OutputType('Google.Apis.Tasks.v1.Data.TaskList')]
    [cmdletbinding(DefaultParameterSetName = "List")]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true,ParameterSetName = "Get")]
        [Alias('Id')]
        [String[]]
        $Tasklist,
        [parameter(Mandatory = $false,Position = 1,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail","Email")]
        [ValidateNotNullOrEmpty()]
        [String]
        $User = $Script:PSGSuite.AdminEmail,
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
    Process {
        if ($User -ceq 'me') {
            $User = $Script:PSGSuite.AdminEmail
        }
        elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
        }
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/tasks.readonly'
            ServiceType = 'Google.Apis.Tasks.v1.TasksService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
        switch ($PSCmdlet.ParameterSetName) {
            Get {
                foreach ($list in $Tasklist) {
                    try {
                        Write-Verbose "Getting Tasklist '$list' for user '$User'"
                        $request = $service.Tasklists.Get($list)
                        $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
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
                    Write-Verbose "Getting all Tasklists for user '$User'"
                    $request = $service.Tasklists.List()
                    if ($Limit -gt 0 -and $PageSize -gt $Limit) {
                        Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with first page" -f $PageSize,$Limit)
                        $PageSize = $Limit
                    }
                    $request.MaxResults = $PageSize
                    [int]$i = 1
                    $overLimit = $false
                    do {
                        $result = $request.Execute()
                        $result.Items | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
                        $request.PageToken = $result.NextPageToken
                        [int]$retrieved = ($i + $result.Items.Count) - 1
                        Write-Verbose "Retrieved $retrieved Tasklists..."
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
