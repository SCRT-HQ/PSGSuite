function Remove-GSDrive {
    <#
    .SYNOPSIS
    Removes a Shared Drive

    .DESCRIPTION
    Removes a Shared Drive

    .PARAMETER DriveId
    The Id of the Shared Drive to remove

    .PARAMETER User
    The email or unique Id of the user with permission to delete the Shared Drive

    Defaults to the AdminEmail user

    .EXAMPLE
    Remove-Drive -DriveId "0AJ8Xjq3FcdCKUk9PVA" -Confirm:$false

    Removes the Shared Drive '0AJ8Xjq3FcdCKUk9PVA', skipping confirmation
    #>
    [cmdletbinding(SupportsShouldProcess=$true,ConfirmImpact="High")]
    Param
    (
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('Id','TeamDriveId')]
        [String[]]
        $DriveId,
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
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
        try {
            foreach ($id in $DriveId) {
                if ($PSCmdlet.ShouldProcess("Deleting Shared Drive '$id' from user '$User'")) {
                    Write-Verbose "Deleting Shared Drive '$id' from user '$User'"
                    $request = $service.Drives.Delete($id)
                    $request.Execute()
                    Write-Verbose "Shared Drive '$id' successfully deleted from user '$User'"
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
