function Update-GSTasklist {
    <#
    .SYNOPSIS
    Updates a Tasklist title

    .DESCRIPTION
    Updates a Tasklist title

    .PARAMETER Tasklist
    The unique Id of the Tasklist to update

    .PARAMETER Title
    The new title of the Tasklist

    .PARAMETER User
    The User who owns the Tasklist.

    Defaults to the AdminUser's email.

    .EXAMPLE
    Update-GSTasklist -Tasklist 'MTA3NjIwMjA1NTEzOTk0MjQ0OTk6NTMyNDY5NDk1NDM5MzMxOTow' -Title 'Hi-Pri Callbacks'

    Updates the specified TaskList with the new title 'Hi-Pri Callbacks'
    #>
    [OutputType('Google.Apis.Tasks.v1.Data.TaskList')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [String]
        $Tasklist,
        [parameter(Mandatory = $true,Position = 1)]
        [String]
        $Title,
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
        try {
            Write-Verbose "Updating Tasklist '$list' to Title '$Title' for user '$User'"
            $body = New-Object 'Google.Apis.Tasks.v1.Data.TaskList' -Property @{
                Title = $Title
            }
            $request = $service.Tasklists.Patch($body,$Tasklist)
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
