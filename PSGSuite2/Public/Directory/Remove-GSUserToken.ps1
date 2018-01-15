function Remove-GSUserToken {
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User,
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [String[]]
        $ClientID
    )
    Begin {
        if ($PSBoundParameters.Keys -contains 'ClientID') {
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
                if ($PSBoundParameters.Keys -contains 'ClientID') {
                    foreach ($C in $ClientID) {
                        if ($PSCmdlet.ShouldProcess("Deleting Token ClientID '$C' for user '$U'")) {
                            Write-Verbose "Deleting Token ClientID '$C' for user '$U'"
                            $request = $service.Tokens.Delete($U,$C)
                            $request.Execute()
                            Write-Verbose "Token ClientID '$C' has been successfully deleted for user '$U'"
                        }
                    }
                }
                else {
                    Get-GSUserToken -User $U | ForEach-Object {
                        Remove-GSUserToken -User $_.User -ClientID $_.ClientID
                    }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}