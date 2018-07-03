function Remove-GSTask {
    <#
    .SYNOPSIS
    Deletes the authenticated user's specified task
    
    .DESCRIPTION
    Deletes the authenticated user's specified task
    
    .PARAMETER Task
    The unique Id of the Task to delete
    
    .PARAMETER Tasklist
    The unique Id of the Tasklist where the Task is
    
    .PARAMETER User
    The User who owns the Tasklist.

    Defaults to the AdminUser's email.
    
    .EXAMPLE
    Remove-GSTask -Task 'MTA3NjIwMjA1NTEzOTk0MjQ0OTk6MDow' -Tasklist 'MTA3NjIwMjA1NTEzOTk0MjQ0OTk6NTMyNDY5NDk1NDM5MzMxO' -Confirm:$false

    Remove the specified Task owned by the AdminEmail user and skips the confirmation check
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('Id')]
        [String[]]
        $Task,
        [parameter(Mandatory = $true,Position = 1)]
        [String]
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
        foreach ($T in $Task) {
            try {
                if ($PSCmdlet.ShouldProcess("Removing Task '$T' from Tasklist '$Tasklist' for user '$User'")) {
                    $request = $service.Tasks.Delete($Tasklist,$T)
                    $request.Execute()
                    Write-Verbose "Successfully removed Task '$T' from Tasklist '$Tasklist' for user '$User'"
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