function New-GSTask {
    <#
    .SYNOPSIS
    Creates a new Task

    .DESCRIPTION
    Creates a new Task

    .PARAMETER Title
    The title of the new Task

    .PARAMETER Tasklist
    The Id of the Tasklist to create the new Task on

    .PARAMETER Completed
    The DateTime of the task completion

    .PARAMETER Due
    The DateTime of the task due date

    .PARAMETER Notes
    Notes describing the task

    .PARAMETER Status
    Status of the task. This is either "needsAction" or "completed".

    .PARAMETER Parent
    Parent task identifier. If the task is created at the top level, this parameter is omitted.

    .PARAMETER Previous
    Previous sibling task identifier. If the task is created at the first position among its siblings, this parameter is omitted.

    .PARAMETER User
    The User to create the Task for.

    Defaults to the AdminUser's email.

    .EXAMPLE
    New-GSTask -Title 'Sweep kitchen','Mow lawn' -Tasklist MTA3NjIwMjA1NTEzOTk0MjQ0OTk6ODEzNTI1MjE3ODk0MTY2MDow

    Creates 2 new Tasks titled 'Sweep kitchen' and 'Mow lawn' for the AdminEmail user on the specified Tasklist Id
    #>
    [OutputType('Google.Apis.Tasks.v1.Data.Task')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true)]
        [String[]]
        $Title,
        [parameter(Mandatory = $true)]
        [String]
        $Tasklist,
        [parameter(Mandatory = $false)]
        [DateTime]
        $Completed,
        [parameter(Mandatory = $false)]
        [DateTime]
        $Due,
        [parameter(Mandatory = $false)]
        [String]
        $Notes,
        [parameter(Mandatory = $false)]
        [ValidateSet('needsAction','completed')]
        [String]
        $Status,
        [parameter(Mandatory = $false)]
        [String]
        $Parent,
        [parameter(Mandatory = $false)]
        [String]
        $Previous,
        [parameter(Mandatory = $false)]
        [Alias("PrimaryEmail","UserKey","Mail","Email")]
        [ValidateNotNullOrEmpty()]
        [String]
        $User = $Script:PSGSuite.AdminEmail
    )
    Begin {
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
    }
    Process {
        foreach ($T in $Title) {
            try {
                Write-Verbose "Creating Task '$T' on Tasklist '$Tasklist' for user '$User'"
                $body = New-Object 'Google.Apis.Tasks.v1.Data.Task'
                foreach ($key in $PSBoundParameters.Keys | Where-Object {$body.PSObject.Properties.Name -contains $_}) {
                    switch ($key) {
                        Parent {}
                        default {
                            if ($body.PSObject.Properties.Name -contains $key) {
                                $body.$key = $PSBoundParameters[$key]
                            }
                        }
                    }
                }
                $request = $service.Tasks.Insert($body,$Tasklist)
                foreach ($key in $PSBoundParameters.Keys | Where-Object {$request.PSObject.Properties.Name -contains $_}) {
                    switch ($key) {
                        Tasklist {}
                        default {
                            if ($request.PSObject.Properties.Name -contains $key) {
                                $request.$key = $PSBoundParameters[$key]
                            }
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
