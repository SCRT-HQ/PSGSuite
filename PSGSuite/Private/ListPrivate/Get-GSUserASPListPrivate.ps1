function Get-GSUserASPListPrivate {
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
        foreach ($U in $User) {
            try {
                if ($U -ceq 'me') {
                    $U = $Script:PSGSuite.AdminEmail
                }
                elseif ($U -notlike "*@*.*") {
                    $U = "$($U)@$($Script:PSGSuite.Domain)"
                }
                Write-Verbose "Getting ASP list for User '$U'"
                $request = $service.Asps.List($U)
                $result = $request.Execute()
                if ($null -ne $result.Items) {
                    $result.Items | Add-Member -MemberType NoteProperty -Name 'User' -Value $U -PassThru
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