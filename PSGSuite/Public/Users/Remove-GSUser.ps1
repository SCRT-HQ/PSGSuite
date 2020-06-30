function Remove-GSUser {
    <#
    .SYNOPSIS
    Removes a user

    .DESCRIPTION
    Removes a user

    .PARAMETER User
    The primary email or unique Id of the user to Remove-GSUser

    .EXAMPLE
    Remove-GSUser joe -Confirm:$false

    Removes the user 'joe@domain.com', skipping confirmation
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User
    )
    Process {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.user'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
        foreach ($U in $User) {
            try {
                if ($U -notlike "*@*.*") {
                    $U = "$($U)@$($Script:PSGSuite.Domain)"
                }
                if ($PSCmdlet.ShouldProcess("Deleting user '$U'")) {
                    Write-Verbose "Deleting user '$U'"
                    $request = $service.Users.Delete($U)
                    $request.Execute()
                    Write-Verbose "User '$U' has been successfully deleted"
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
