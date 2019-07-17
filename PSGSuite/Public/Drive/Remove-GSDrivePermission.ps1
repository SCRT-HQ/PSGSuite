function Remove-GSDrivePermission {
    <#
    .SYNOPSIS
    Removes a permission from a Drive file

    .DESCRIPTION
    Removes a permission from a Drive file

    .PARAMETER User
    The email or unique Id of the user whose Drive file permission you are trying to get

    Defaults to the AdminEmail user

    .PARAMETER FileId
    The unique Id of the Drive file

    .PARAMETER PermissionId
    The unique Id of the permission you are trying to remove.

    .EXAMPLE
    Remove-GSDrivePermission -FileId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976' -PermissionID 'sdfadsfsdafasd'

    Removes the permission from the drive.

    .EXAMPLE
    Get-GSDrivePermission -FileId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976' | ? {$_.Type -eq 'group'} | Remove-GSDrivePermission

    Gets the permissions assigned to groups and removes them.
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias('Id')]
        [String]
        $FileId,
        [parameter(Mandatory = $false,Position = 1,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('Id')]
        [String]
        $PermissionId
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
            if ($PSCmdlet.ShouldProcess("Removing Drive Permission Id '$PermissionId' from FileId '$FileID'")) {
                $request = $service.Permissions.Delete($FileId,$PermissionId)
                $request.SupportsAllDrives = $true
                $request.Execute()
                Write-Verbose "Successfully removed Drive Permission Id '$PermissionId' from FileId '$FileID'"
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
