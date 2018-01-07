function Get-GSUserTokenList {
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User = $Script:PSGSuite.AdminEmail
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.user.security'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            foreach ($U in $User) {
                if ($U -notlike "*@*.*") {
                    $U = "$($U)@$($Script:PSGSuite.Domain)"
                }
                Write-Verbose "Listing tokens for user '$U'"
                $request = $service.Tokens.List($U)
                $request.Execute() | Select-Object -ExpandProperty Items | Select-Object @{N = "User";E = {$U}},*
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}