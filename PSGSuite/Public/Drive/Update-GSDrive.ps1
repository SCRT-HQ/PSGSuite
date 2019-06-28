function Update-GSDrive {
    <#
    .SYNOPSIS
    Update metatdata for a Shared Drive

    .DESCRIPTION
    Update metatdata for a Shared Drive

    .PARAMETER DriveId
    The unique Id of the Shared Drive to update

    .PARAMETER User
    The user to create the Shared Drive for (must have permissions to create Shared Drives)

    .PARAMETER Name
    The name of the Shared Drive

    .PARAMETER CanAddChildren
    Whether the current user can add children to folders in this Shared Drive

    .PARAMETER CanChangeDriveBackground
    Whether the current user can change the background of this Shared Drive

    .PARAMETER CanComment
    Whether the current user can comment on files in this Shared Drive

    .PARAMETER CanCopy
    Whether the current user can copy files in this Shared Drive

    .PARAMETER CanDeleteDrive
    Whether the current user can delete this Shared Drive. Attempting to delete the Shared Drive may still fail if there are untrashed items inside the Shared Drive

    .PARAMETER CanDownload
    Whether the current user can download files in this Shared Drive

    .PARAMETER CanEdit
    Whether the current user can edit files in this Shared Drive

    .PARAMETER CanListChildren
    Whether the current user can list the children of folders in this Shared Drive

    .PARAMETER CanManageMembers
    Whether the current user can add members to this Shared Drive or remove them or change their role

    .PARAMETER CanReadRevisions
    Whether the current user can read the revisions resource of files in this Shared Drive

    .PARAMETER CanRemoveChildren
    Whether the current user can remove children from folders in this Shared Drive

    .PARAMETER CanRename
    Whether the current user can rename files or folders in this Shared Drive

    .PARAMETER CanRenameDrive
    Whether the current user can rename this Shared Drive

    .PARAMETER CanShare
    Whether the current user can share files or folders in this Shared Drive

    .EXAMPLE
    Update-GSDrive -DriveId '0AJ8Xjq3FcdCKUk9PVA' -Name "HR Document Repo"

    Updated the Shared Drive with a new name, "HR Document Repo"
    #>
    [OutputType('Google.Apis.Drive.v3.Data.Drive')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [Alias('Id','TeamDriveId')]
        [String]
        $DriveId,
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false)]
        [String]
        $Name,
        [parameter(Mandatory = $false)]
        [Switch]
        $CanAddChildren,
        [parameter(Mandatory = $false)]
        [Alias('CanChangeTeamDriveBackground')]
        [Switch]
        $CanChangeDriveBackground,
        [parameter(Mandatory = $false)]
        [Switch]
        $CanComment,
        [parameter(Mandatory = $false)]
        [Switch]
        $CanCopy,
        [parameter(Mandatory = $false)]
        [Alias('CanDeleteTeamDrive')]
        [Switch]
        $CanDeleteDrive,
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
        [Alias('CanRenameTeamDrive')]
        [Switch]
        $CanRenameDrive,
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
            $body = New-Object 'Google.Apis.Drive.v3.Data.Drive'
            $capabilities = New-Object 'Google.Apis.Drive.v3.Data.Drive+CapabilitiesData'
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
            $request = $service.Drives.Update($body,$DriveId)
            Write-Verbose "Updating Shared Drive '$Name' for user '$User'"
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
