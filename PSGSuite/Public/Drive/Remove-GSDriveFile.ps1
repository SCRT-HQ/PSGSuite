function Remove-GSDriveFile {
    <#
    .SYNOPSIS
    Deletes a Drive file

    .DESCRIPTION
    Deletes a Drive file

    .PARAMETER FileId
    The unique Id(s) of the file(s) to delete

    .PARAMETER User
    The email or unique Id of the owner of the Drive file

    Defaults to the AdminEmail user

    .EXAMPLE
    Remove-GSDriveFile -FileId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976' -User user@domain.com

    Deletes the file with ID 1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976 from the user user@domain.com's Drive

    .EXAMPLE
    Get-GSDriveFileList -ParentFolderId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976' -User user@domain.com | Remove-GSDriveFile

    Get the file with ID 1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976 from the user user@domain.com's Drive and pipeline
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    Param(
        [parameter(Mandatory,ValueFromPipelineByPropertyName,Position = 0)]
        [Alias('Id')]
        [String[]]
        $FileId,
        [parameter(ValueFromPipelineByPropertyName,Position = 1)]
        [Alias('Owner', 'PrimaryEmail', 'UserKey', 'Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail
    )
    Process {
        Resolve-Email ([ref]$User)
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/drive'
            ServiceType = 'Google.Apis.Drive.v3.DriveService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
        foreach ($file in $FileId) {
            try {
                if ($PSCmdlet.ShouldProcess("Deleting File Id '$FileId' from user '$User'")) {
                    Write-Verbose "Deleting File Id '$FileId' from user '$User'"
                    $request = $service.Files.Delete($FileId)
                    $request.SupportsAllDrives = $true
                    $request.Execute() | Out-Null
                    Write-Verbose "File Id '$FileId' successfully deleted from user '$User'"
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
