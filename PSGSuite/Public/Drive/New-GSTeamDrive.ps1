function New-GSTeamDrive {
    <#
    .SYNOPSIS
    Creates a new Team Drive

    .DESCRIPTION
    Creates a new Team Drive

    .PARAMETER Name
    The name of the Team Drive

    .PARAMETER User
    The user to create the Team Drive for (must have permissions to create Team Drives)

    .PARAMETER RequestId
    An ID, such as a random UUID, which uniquely identifies this user's request for idempotent creation of a Team Drive. A repeated request by the same user and with the same request ID will avoid creating duplicates by attempting to create the same Team Drive. If the Team Drive already exists a 409 error will be returned.

    .PARAMETER CanAddChildren
    Whether the current user can add children to folders in this Team Drive

    .PARAMETER CanChangeTeamDriveBackground
    Whether the current user can change the background of this Team Drive

    .PARAMETER CanComment
    Whether the current user can comment on files in this Team Drive

    .PARAMETER CanCopy
    Whether the current user can copy files in this Team Drive

    .PARAMETER CanDeleteTeamDrive
    Whether the current user can delete this Team Drive. Attempting to delete the Team Drive may still fail if there are untrashed items inside the Team Drive

    .PARAMETER CanDownload
    Whether the current user can download files in this Team Drive

    .PARAMETER CanEdit
    Whether the current user can edit files in this Team Drive

    .PARAMETER CanListChildren
    Whether the current user can list the children of folders in this Team Drive

    .PARAMETER CanManageMembers
    Whether the current user can add members to this Team Drive or remove them or change their role

    .PARAMETER CanReadRevisions
    Whether the current user can read the revisions resource of files in this Team Drive

    .PARAMETER CanRemoveChildren
    Whether the current user can remove children from folders in this Team Drive

    .PARAMETER CanRename
    Whether the current user can rename files or folders in this Team Drive

    .PARAMETER CanRenameTeamDrive
    Whether the current user can rename this Team Drive

    .PARAMETER CanShare
    Whether the current user can share files or folders in this Team Drive

    .EXAMPLE
    New-GSTeamDrive -Name "Training Docs"

    Creates a new Team Drive named "Training Docs"
    #>
    [OutputType('Google.Apis.Drive.v3.Data.TeamDrive')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [String]
        $Name,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $RequestId = (New-Guid).ToString('N'),
        [parameter(Mandatory = $false)]
        [Switch]
        $CanAddChildren,
        [parameter(Mandatory = $false)]
        [Switch]
        $CanChangeTeamDriveBackground,
        [parameter(Mandatory = $false)]
        [Switch]
        $CanComment,
        [parameter(Mandatory = $false)]
        [Switch]
        $CanCopy,
        [parameter(Mandatory = $false)]
        [Switch]
        $CanDeleteTeamDrive,
        [parameter(Mandatory = $false)]
        [Switch]
        $CanDownload,
        [parameter(Mandatory = $false)]
        [Switch]
        $CanEdit,
        [parameter(Mandatory = $false)]
        [Switch]
        $CanListChildren,
        [parameter(Mandatory = $false)]
        [Switch]
        $CanManageMembers,
        [parameter(Mandatory = $false)]
        [Switch]
        $CanReadRevisions,
        [parameter(Mandatory = $false)]
        [Switch]
        $CanRemoveChildren,
        [parameter(Mandatory = $false)]
        [Switch]
        $CanRename,
        [parameter(Mandatory = $false)]
        [Switch]
        $CanRenameTeamDrive,
        [parameter(Mandatory = $false)]
        [Switch]
        $CanShare
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
        try {
            $body = New-Object 'Google.Apis.Drive.v3.Data.TeamDrive'
            $capabilities = New-Object 'Google.Apis.Drive.v3.Data.TeamDrive+CapabilitiesData'
            foreach ($key in $PSBoundParameters.Keys) {
                switch ($key) {
                    Default {
                        if ($capabilities.PSObject.Properties.Name -contains $key) {
                            $capabilities.$key = $PSBoundParameters[$key]
                        }
                        elseif ($body.PSObject.Properties.Name -contains $key) {
                            $body.$key = $PSBoundParameters[$key]
                        }
                    }
                }
            }
            $body.Capabilities = $capabilities
            $request = $service.Teamdrives.Create($body,$RequestId)
            Write-Verbose "Creating Team Drive '$Name' for user '$User'"
            $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru | Add-Member -MemberType NoteProperty -Name 'RequestId' -Value $RequestId -PassThru
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
