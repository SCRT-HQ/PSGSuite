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
                if ($PSBoundParameters.Keys -contains 'CodeId') {
                    $request = $service.Asps.Get($U,$CodeId)
                    $request.Execute() | Select-Object @{N = "User";E = {$U}},*
                }
                else {
                    $PSBoundParameters['User'] = $U
                    Get-GSUserASPList @PSBoundParameters
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}