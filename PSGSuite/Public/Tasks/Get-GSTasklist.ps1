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
    
    .EXAMPLE
    Get-GSTasklist

    Gets the list of Tasklists owned by the AdminEmail user
    
    .EXAMPLE
    Get-GSTasklist -Tasklist MTUzNTU0MDYscM0NjKDMTIyNjQ6MDow -User john@domain.com

    Gets the Tasklist matching the provided Id owned by John
    #>
    [cmdletbinding(DefaultParameterSetName = "List")]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true,ParameterSetName = "Get")]
        [Alias('Id')]
        [String[]]
        $Tasklist,
        [parameter(Mandatory = $false,Position = 1)]
        [Alias("PrimaryEmail","UserKey","Mail","Email")]
        [ValidateNotNullOrEmpty()]
        [String]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [ValidateRange(1,100)]
        [Alias("MaxResults")]
        [Int]
        $PageSize
    )
    Begin {
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
    }
    Process {
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
                    if ($PSBoundParameters.Keys -contains 'PageSize') {
                        $request.MaxResults = $PSBoundParameters['PageSize']
                    }
                    [int]$i = 1
                    do {
                        $result = $request.Execute()
                        $result.Items | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
                        $request.PageToken = $result.NextPageToken
                        [int]$retrieved = ($i + $result.Items.Count) - 1
                        Write-Verbose "Retrieved $retrieved Tasklists..."
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