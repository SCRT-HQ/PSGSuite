function Clear-GSTasklist {
    <#
    .SYNOPSIS
    Clears all completed tasks from the specified task list. The affected tasks will be marked as 'hidden' and no longer be returned by default when retrieving all tasks for a task list
    
    .DESCRIPTION
    Clears all completed tasks from the specified task list. The affected tasks will be marked as 'hidden' and no longer be returned by default when retrieving all tasks for a task list
    
    .PARAMETER Tasklist
    The unique Id of the Tasklist to clear
    
    .PARAMETER User
    The User who owns the Tasklist.

    Defaults to the AdminUser's email.
    
    .EXAMPLE
    Clear-GSTasklist -Tasklist 'MTA3NjIwMjA1NTEzOTk0MjQ0OTk6NTMyNDY5NDk1NDM5MzMxO' -Confirm:$false

    Clears the specified Tasklist owned by the AdminEmail user and skips the confirmation check
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('Id')]
        [String[]]
        $Tasklist,
        [parameter(Mandatory = $false,Position = 1)]
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
        foreach ($list in $Tasklist) {
            try {
                if ($PSCmdlet.ShouldProcess("Clearing Tasklist '$list' for user '$User'")) {
                    $request = $service.Tasks.Clear($list)
                    $request.Execute()
                    Write-Verbose "Successfully cleared Tasklist '$list' for user '$User'"
                }
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