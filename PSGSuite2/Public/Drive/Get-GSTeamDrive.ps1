function Get-GSTeamDrive {
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('Id')]
        [String[]]
        $TeamDriveId,
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
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
            Scope       = 'https://www.googleapis.com/auth/drive'
            ServiceType = 'Google.Apis.Drive.v3.DriveService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            foreach ($id in $TeamDriveId) {
                $request = $service.Teamdrives.Get($id)
                Write-Verbose "Getting Team Drive '$id' for user '$User'"
                $request.Execute() | Select-Object @{N = "User";E = {$User}},*
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}