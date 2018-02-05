function New-GSUserVerificationCodes {
    <#
    .SYNOPSIS
    Generates new verification codes for the user
    
    .DESCRIPTION
    Generates new verification codes for the user
    
    .PARAMETER User
    The primary email or UserID of the user who you are trying to get info for. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config
    
    .EXAMPLE
    New-GSUserVerificationCodes -User me

    Generates new verification codes for the AdminEmail user
    #>
    [cmdletbinding()]
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
            Scope       = 'https://www.googleapis.com/auth/admin.directory.user.security'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
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
                Write-Verbose "Generating new verification codes for user '$U'"
                $request = $service.VerificationCodes.Generate($U)
                $request.Execute()
                Write-Verbose "New verification codes successfully generated for user '$U'"
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}