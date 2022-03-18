function Remove-GSDriveRevision {
    <#
    .SYNOPSIS
    Permanently deletes a file version.

    .DESCRIPTION
    Permanently deletes a file version.

    You can only delete revisions for files with binary content in Google Drive, like images or videos. Revisions for other files, like Google Docs or Sheets, and the last remaining file version can't be deleted.

    .PARAMETER FileId
    The unique Id of the file to remove revisions from

    .PARAMETER RevisionId
    The unique Id of the revision to remove

    .PARAMETER User
    The email or unique Id of the owner of the Drive file

    Defaults to the AdminEmail user

    .EXAMPLE
    Get-GSDriveRevision -FileId $fileId -Limit 1 | Remove-GSDriveRevision

    Removes the oldest revision for the file

    .EXAMPLE
    Get-GSDriveRevision -FileId $fileId | Select-Object -Last 1 | Remove-GSDriveRevision

    Removes the newest revision for the file
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [String]
        $FileId,
        [parameter(Mandatory = $true,Position = 1,ValueFromPipelineByPropertyName = $true)]
        [Alias('Id')]
        [String[]]
        $RevisionId,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail
    )
    Process {
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
        foreach ($id in $RevisionId) {
            try {
                if ($PSCmdlet.ShouldProcess("Removing Drive Revision Id '$id' from FileId '$FileID' for user '$User'")) {
                    $request = $service.Revisions.Delete($FileId,$id)
                    $request.Execute()
                    Write-Verbose "Successfully removed Drive Revision Id '$id' from FileId '$FileID' for user '$User'"
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
