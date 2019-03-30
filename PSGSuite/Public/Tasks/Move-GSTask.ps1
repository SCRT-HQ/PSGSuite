function Move-GSTask {
    <#
    .SYNOPSIS
    Moves the specified task to another position in the task list. This can include putting it as a child task under a new parent and/or move it to a different position among its sibling tasks.

    .DESCRIPTION
    Moves the specified task to another position in the task list. This can include putting it as a child task under a new parent and/or move it to a different position among its sibling tasks.

    .PARAMETER Tasklist
    The unique Id of the Tasklist where the Task currently resides

    .PARAMETER Task
    The unique Id of the Task to move

    .PARAMETER Parent
    Parent task identifier. If the task is created at the top level, this parameter is omitted.

    .PARAMETER Previous
    Previous sibling task identifier. If the task is created at the first position among its siblings, this parameter is omitted.

    .PARAMETER User
    The User who owns the Tasklist.

    Defaults to the AdminUser's email.

    .EXAMPLE
    Clear-GSTasklist -Tasklist 'MTA3NjIwMjA1NTEzOTk0MjQ0OTk6NTMyNDY5NDk1NDM5MzMxO' -Confirm:$false

    Clears the specified Tasklist owned by the AdminEmail user and skips the confirmation check
    #>
    [OutputType('Google.Apis.Tasks.v1.Data.Task')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [String]
        $Tasklist,
        [parameter(Mandatory = $true,Position = 1,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('Id')]
        [String[]]
        $Task,
        [parameter(Mandatory = $false)]
        [String]
        $Parent,
        [parameter(Mandatory = $false)]
        [String]
        $Previous,
        [parameter(Mandatory = $false,Position = 1,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail","Email")]
        [ValidateNotNullOrEmpty()]
        [String]
        $User = $Script:PSGSuite.AdminEmail
    )
    Process {
        if ($User -ceq 'me') {
            $User = $Script:PSGSuite.AdminEmail
        }
        elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
        }
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/tasks'
            ServiceType = 'Google.Apis.Tasks.v1.TasksService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
        foreach ($T in $Task) {
            try {
                Write-Verbose "Moving Task '$T' for user '$User'"
                $request = $service.Tasks.Move($Tasklist,$T)
                foreach ($key in $PSBoundParameters.Keys | Where-Object {$request.PSObject.Properties.Name -contains $_}) {
                    switch ($key) {
                        {$_ -in @('Parent','Previous')} {
                            $request.$key = $PSBoundParameters[$key]
                        }
                    }
                }
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
}
