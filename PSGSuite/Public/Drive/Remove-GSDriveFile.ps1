function Remove-GSDriveFile {
    <#
    .SYNOPSIS
    Deletes a Drive file

    .DESCRIPTION
    Deletes a Drive file

    .PARAMETER FileId
    The unique Id of the file to get

    .PARAMETER User
    The email or unique Id of the owner of the Drive file

    Defaults to the AdminEmail user

    .EXAMPLE
    Remove-GSDriveFile -User user@domain.com -FileId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976'

    Deletes the file with ID 1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976 from the user user@domain.com's Drive
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true, Position = 0)]
        [String[]]
        $FileId,
        [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner', 'PrimaryEmail', 'UserKey', 'Mail')]
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
            if ($PSCmdlet.ShouldProcess("Deleting File Id(s) '$FileId' from user '$User'")) {
                foreach ($file in $FileId) {
                    $request = $service.Files.Delete($file)
                    #$request.SupportsTeamDrives = $true
                    $request.Execute()
                }
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