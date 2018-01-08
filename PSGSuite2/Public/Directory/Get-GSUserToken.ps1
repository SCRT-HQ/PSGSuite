function Get-GSUserToken {
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
        $ClientId
    )
    Begin {
        if ($PSBoundParameters.Keys -contains 'ClientId') {
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
                if ($PSBoundParameters.Keys -contains 'ClientId') {
                    Write-Verbose "Getting Token '$ClientId' for User '$U'"
                    $request = $service.Tokens.Get($U,$ClientId)
                    $request.Execute() | Select-Object @{N = "User";E = {$U}},*
                }
                else {
                    $PSBoundParameters['User'] = $U
                    Get-GSUserTokenList @PSBoundParameters
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}