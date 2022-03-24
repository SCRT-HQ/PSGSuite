function Remove-GSUserASP {
    <#
    .SYNOPSIS
    Removes an Application Specific Password for a user

    .DESCRIPTION
    Removes an Application Specific Password for a user

    .PARAMETER User
    The user to remove ASPs ValueFromPipeline

    .PARAMETER CodeId
    The ASP Code Id to remove. If excluded, all ASPs for the user will be removed

    .EXAMPLE
    Remove-GSUserASP -User joe

    Removes *ALL* ASPs from joe@domain.com's account after confirmation
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [String[]]
        $CodeId
    )
    Process {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.user.security'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
        try {
            foreach ($U in $User) {
                if ($U -ceq 'me') {
                    $U = $Script:PSGSuite.AdminEmail
                }
                elseif ($U -notlike "*@*.*") {
                    $U = "$($U)@$($Script:PSGSuite.Domain)"
                }
                if ($PSBoundParameters.Keys -contains 'CodeId') {
                    foreach ($C in $CodeId) {
                        if ($PSCmdlet.ShouldProcess("Deleting ASP CodeId '$C' for user '$U'")) {
                            Write-Verbose "Deleting ASP CodeId '$C' for user '$U'"
                            $request = $service.Asps.Delete($U,$C)
                            $request.Execute()
                            Write-Verbose "ASP CodeId '$C' has been successfully deleted for user '$U'"
                        }
                    }
                }
                else {
                    if ($PSCmdlet.ShouldProcess("Deleting ALL ASPs for user '$U'")) {
                        Write-Verbose "Deleting ALL ASPs for user '$U'"
                        Get-GSUserASP -User $U -Verbose:$false | ForEach-Object {
                            $request = $service.Asps.Delete($U,$_.CodeId)
                            $request.Execute()
                            Write-Verbose "ASP CodeId '$($_.CodeId)' has been successfully deleted for user '$U'"
                        }
                    }
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
