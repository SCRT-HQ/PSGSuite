function Remove-GSDriveFile {
    <#
    .SYNOPSIS
    Gets information about or downloads a Drive file

    .DESCRIPTION
    Gets information about or downloads a Drive file

    .PARAMETER FileId
    The unique Id of the file to get

    .PARAMETER User
    The email or unique Id of the owner of the Drive file

    Defaults to the AdminEmail user

    .PARAMETER OutFilePath
    The directory path that you would like to download the Drive file to. If excluded, only the Drive file information will be returned

    .PARAMETER Projection
    The defined subset of fields to be returned

    Available values are:
    * "Minimal"
    * "Standard"
    * "Full"
    * "Access"

    .PARAMETER Fields
    The specific fields to returned

    .EXAMPLE
    Get-GSDriveFile -FileId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976'

    Gets the information for the file

    .EXAMPLE
    Get-GSDriveFile -FileId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976' -OutFilePath (Get-Location).Path

    Gets the information for the file and saves the file in the current working directory
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [String[]]
        $FileId,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
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
            foreach ($file in $FileId) {
                $request = $service.Files.Delete($file)
                #$request.SupportsTeamDrives = $true
                $request.Execute()
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