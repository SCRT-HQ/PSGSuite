function Get-GSTask {
    <#
    .SYNOPSIS
    Gets a specific Task or the list of Tasks

    .DESCRIPTION
    Gets a specific Task or the list of Tasks

    .PARAMETER User
    The User who owns the Task.

    Defaults to the AdminUser's email.

    .PARAMETER Task
    The unique Id of the Task.

    If left blank, returns the list of Tasks on the Tasklist

    .PARAMETER Tasklist
    The unique Id of the Tasklist the Task is on.

    .PARAMETER PageSize
    Page size of the result set

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
        $PageSize
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
                    if ($PSBoundParameters.Keys -contains 'PageSize') {
                        $request.MaxResults = $PSBoundParameters['PageSize']
                    }
                    [int]$i = 1
                    do {
                        $result = $request.Execute()
                        $result.Items | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
                        $request.PageToken = $result.NextPageToken
                        [int]$retrieved = ($i + $result.Items.Count) - 1
                        Write-Verbose "Retrieved $retrieved Tasks..."
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
