function New-GSTasklist {
    <#
    .SYNOPSIS
    Creates a new Tasklist

    .DESCRIPTION
    Creates a new Tasklist

    .PARAMETER User
    The User to create the Tasklist for.

    Defaults to the AdminUser's email.

    .PARAMETER Title
    The title of the new Tasklist

    .EXAMPLE
    New-GSTasklist -Title 'Chores','Projects'

    Creates 2 new Tasklists titled 'Chores' and 'Projects' for the AdminEmail user
    #>
    [OutputType('Google.Apis.Tasks.v1.Data.TaskList')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [String[]]
        $Title,
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
        foreach ($list in $Title) {
            try {
                Write-Verbose "Creating Tasklist '$list' for user '$User'"
                $body = New-Object 'Google.Apis.Tasks.v1.Data.TaskList' -Property @{
                    Title = $list
                }
                $request = $service.Tasklists.Insert($body)
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
