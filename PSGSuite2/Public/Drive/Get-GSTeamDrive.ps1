function Get-GSTeamDrive {
    [cmdletbinding(DefaultParameterSetName = "List")]
    Param
    (
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true,ParameterSetName = "Get")]
        [Alias('Id')]
        [String[]]
        $TeamDriveId,
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [ValidateScript( {[int]$_ -le 100})]
        [Int]
        $Query,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [ValidateScript( {[int]$_ -le 100})]
        [Int]
        $PageSize = "100"
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
            switch ($PSCmdlet.ParameterSetName) {
                Get {
                    foreach ($id in $TeamDriveId) {
                        $request = $service.Teamdrives.Get($id)
                        Write-Verbose "Getting Team Drive '$id' for user '$User'"
                        $request.Execute() | Select-Object @{N = "User";E = {$User}},*
                    }
                }
                List {
                    $request = $service.Teamdrives.List()
                    $request.PageSize = $PageSize
                    Write-Verbose "Getting Team Drives for user '$User'"
                    $request.Execute() | Select-Object -ExpandProperty TeamDrives | Select-Object @{N = "User";E = {$User}},*
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}