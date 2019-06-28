function Show-GSDrive {
    <#
    .SYNOPSIS
    Shows (unhides) a Shared Drive in the default view

    .DESCRIPTION
    Shows (unhides) a Shared Drive in the default view

    .PARAMETER DriveId
    The unique Id of the Shared Drive to unhide

    .PARAMETER User
    The email or unique Id of the user who you'd like to unhide the Shared Drive for.

    Defaults to the AdminEmail user.

    .EXAMPLE
    Show-GSDrive -DriveId $driveIds

    Unhides the specified DriveIds for the AdminEmail user
    #>
    [OutputType('Google.Apis.Drive.v3.Data.Drive')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true,ParameterSetName = "Get")]
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
        foreach ($id in $DriveId) {
            try {
                $request = $service.Drives.Unhide($id)
                Write-Verbose "Unhiding Shared Drive '$id' for user '$User'"
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
}
