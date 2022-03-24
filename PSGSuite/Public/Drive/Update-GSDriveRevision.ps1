function Update-GSDriveRevision {
    <#
    .SYNOPSIS
    Updates a revision with patch semantics

    .DESCRIPTION
    Updates a revision with patch semantics

    .PARAMETER FileId
    The unique Id of the file to update revisions for

    .PARAMETER RevisionId
    The unique Id of the revision to update

    .PARAMETER KeepForever
    Whether to keep this revision forever, even if it is no longer the head revision. If not set, the revision will be automatically purged 30 days after newer content is uploaded. This can be set on a maximum of 200 revisions for a file.

    This field is only applicable to files with binary content in Drive.

    .PARAMETER PublishAuto
    Whether subsequent revisions will be automatically republished. This is only applicable to Google Docs.

    .PARAMETER Published
    Whether this revision is published. This is only applicable to Google Docs.

    .PARAMETER PublishedOutsideDomain
    Whether this revision is published outside the domain. This is only applicable to Google Docs.

    .PARAMETER Fields
    The specific fields to returned

    .PARAMETER User
    The email or unique Id of the owner of the Drive file

    Defaults to the AdminEmail user

    .EXAMPLE
    Get-GSDriveRevision -FileId $fileId -Limit 1 | Update-GSDriveRevision -KeepForever

    Sets 'KeepForever' for the oldest revision of the file to 'True'

    .EXAMPLE
    Get-GSDriveRevision -FileId $fileId | Select-Object -Last 1 | Update-GSDriveRevision -KeepForever

    Sets 'KeepForever' for the newest revision of the file to 'True'
    #>
    [OutputType('Google.Apis.Drive.v3.Data.Revision')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [String]
        $FileId,
        [parameter(Mandatory = $true,Position = 1,ValueFromPipelineByPropertyName = $true)]
        [Alias('Id')]
        [String[]]
        $RevisionId,
        [parameter(Mandatory = $false)]
        [Switch]
        $KeepForever,
        [parameter(Mandatory = $false)]
        [Switch]
        $PublishAuto,
        [parameter(Mandatory = $false)]
        [Switch]
        $Published,
        [parameter(Mandatory = $false)]
        [Switch]
        $PublishedOutsideDomain,
        [parameter(Mandatory = $false)]
        [String[]]
        $Fields = '*',
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
        $body = New-Object 'Google.Apis.Drive.v3.Data.Revision'
        foreach ($key in $PSBoundParameters.Keys | Where-Object {$_ -in $body.PSObject.Properties.Name}) {
            $body.$key = $PSBoundParameters[$key]
        }
        foreach ($id in $RevisionId) {
            try {
                $request = $service.Revisions.Update($body,$FileId,$id)
                if ($Fields) {
                    $request.Fields = $($Fields -join ",")
                }
                Write-Verbose "Updating Drive File Revision Id '$revision' of File Id '$FileId' for User '$User'"
                $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru | Add-Member -MemberType NoteProperty -Name 'FileId' -Value $FileId -PassThru
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
