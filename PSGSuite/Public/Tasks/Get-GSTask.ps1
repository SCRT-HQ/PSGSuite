function Get-GSTask {
    <#
    .SYNOPSIS
    Gets a specific Task or the list of Tasks

    .DESCRIPTION
    Gets a specific Task or the list of Tasks

    .PARAMETER Task
    The unique Id of the Task.

    If left blank, returns the list of Tasks on the Tasklist

    .PARAMETER Tasklist
    The unique Id of the Tasklist the Task is on.

    .PARAMETER User
    The User who owns the Task.

    Defaults to the AdminUser's email.

    .PARAMETER CompletedMax
    Upper bound for a task's completion date to filter by.

    .PARAMETER CompletedMin
    Lower bound for a task's completion date to filter by.

    .PARAMETER DueMax
    Upper bound for a task's due date to filter by.

    .PARAMETER DueMin
    Lower bound for a task's due date to filter by.

    .PARAMETER UpdatedMin
    Lower bound for a task's last modification time to filter by.

    .PARAMETER ShowCompleted
    Flag indicating whether completed tasks are returned in the result.

    .PARAMETER ShowDeleted
    Flag indicating whether deleted tasks are returned in the result.

    .PARAMETER ShowHidden
    Flag indicating whether hidden tasks are returned in the result.

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
    [OutputType('Google.Apis.Tasks.v1.Data.Task')]
    [cmdletbinding(DefaultParameterSetName = "List")]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true,ParameterSetName = "Get")]
        [Alias('Id')]
        [String[]]
        $Task,
        [parameter(Mandatory = $true,Position = 1)]
        [String]
        $Tasklist,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail","Email")]
        [ValidateNotNullOrEmpty()]
        [String]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [DateTime]
        $CompletedMax,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [DateTime]
        $CompletedMin,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [DateTime]
        $DueMax,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [DateTime]
        $DueMin,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [DateTime]
        $UpdatedMin,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Switch]
        $ShowCompleted,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Switch]
        $ShowDeleted,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Switch]
        $ShowHidden,
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
                foreach ($T in $Task) {
                    try {
                        Write-Verbose "Getting Task '$T' from Tasklist '$Tasklist' for user '$User'"
                        $request = $service.Tasks.Get($Tasklist,$T)
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
                    Write-Verbose "Getting all Tasks from Tasklist '$Tasklist' for user '$User'"
                    $request = $service.Tasks.List($Tasklist)
                    foreach ($key in $PSBoundParameters.Keys | Where-Object {$request.PSObject.Properties.Name -contains $_}) {
                        switch ($key) {
                            Tasklist {}
                            {$_ -in @('CompletedMax','CompletedMin','DueMax','DueMin','UpdatedMin')} {
                                $request.$key = ($PSBoundParameters[$key]).ToString('o')
                            }
                            default {
                                if ($request.PSObject.Properties.Name -contains $key) {
                                    $request.$key = $PSBoundParameters[$key]
                                }
                            }
                        }
                    }
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
                        Write-Verbose "Retrieved $retrieved Tasks..."
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
