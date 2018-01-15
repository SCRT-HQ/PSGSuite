function Remove-GSUserASP {
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
    Begin {
        if ($PSBoundParameters.Keys -contains 'CodeId') {
            $serviceParams = @{
                Scope       = 'https://www.googleapis.com/auth/admin.directory.user.security'
                ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
            }
            $service = New-GoogleService @serviceParams
        }
    }
    Process {
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
                    Get-GSUserASP -User $U | ForEach-Object {
                        Remove-GSUserASP -User $_.User -CodeId $_.CodeId
                    }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}