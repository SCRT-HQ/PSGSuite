function Remove-GSDrivePermission {
    <#
    .SYNOPSIS
    Removes a new permission to a Drive file
    
    .DESCRIPTION
    Removes a new permission to a Drive file
    
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
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail, 
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [String]
        $FileId, 
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('Id')]        
        [String]
        $PermissionId
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
            $request = $service.Permissions.Delete($FileId,$PermissionId)
            $request.SupportsTeamDrives = $true

            Write-Verbose "Removing Drive Permission of PermissionId '$PermissionId' from FileId '$FileID'"
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