function Remove-GSTeamDrive {
    <#
    .SYNOPSIS
    Removes a Team Drive
    
    .DESCRIPTION
    Removes a Team Drive
    
    .PARAMETER TeamDriveId
    The Id of the Team Drive to remove
    
    .PARAMETER User
    The email or unique Id of the user with permission to delete the Team Drive

    Defaults to the AdminEmail user
    
    .EXAMPLE
    Remove-TeamDrive -TeamDriveId "0AJ8Xjq3FcdCKUk9PVA" -Confirm:$false

    Removes the Team Drive '0AJ8Xjq3FcdCKUk9PVA', skipping confirmation
    #>
    [cmdletbinding(SupportsShouldProcess=$true,ConfirmImpact="High")]
    Param
    (
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('Id')]
        [String[]]
        $TeamDriveId,
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
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
            foreach ($id in $TeamDriveId) {
                if ($PSCmdlet.ShouldProcess("Deleting Team Drive '$id' from user '$User'")) {
                    Write-Verbose "Deleting Team Drive '$id' from user '$User'"
                    $request = $service.Teamdrives.Delete($id)
                    $request.Execute()
                    Write-Verbose "Team Drive '$id' successfully deleted from user '$User'"
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