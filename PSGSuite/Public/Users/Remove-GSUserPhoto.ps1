function Remove-GSUserPhoto {
    <#
    .SYNOPSIS
    Removes the photo for the specified user

    .DESCRIPTION
    Removes the photo for the specified user

    .PARAMETER User
    The primary email or UserID of the user who you are trying to remove the photo for. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

    .EXAMPLE
    Remove-GSUserPhoto -User me

    Removes the Google user photo of the AdminEmail user
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.user'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        foreach ($U in $User) {
            try {
                if ($U -ceq 'me') {
                    $U = $Script:PSGSuite.AdminEmail
                }
                elseif ($U -notlike "*@*.*") {
                    $U = "$($U)@$($Script:PSGSuite.Domain)"
                }
                if ($PSCmdlet.ShouldProcess("Removing the photo for User '$U'")) {
                    Write-Verbose "Removing the photo for User '$U'"
                    $request = $service.Users.Photos.Delete($U)
                    $request.Execute()
                    Write-Verbose "Successfully removed the photo for user '$U'"
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