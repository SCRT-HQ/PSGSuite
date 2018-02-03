function Get-GSUserASP {
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false,Position = 1,ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
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
                    Write-Verbose "Getting ASP '$CodeId' for User '$U'"
                    $request = $service.Asps.Get($U,$CodeId)
                    $request.Execute() | Select-Object @{N = "User";E = {$U}},*
                }
                else {
                    $PSBoundParameters['User'] = $U
                    Get-GSUserASPListPrivate @PSBoundParameters
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}