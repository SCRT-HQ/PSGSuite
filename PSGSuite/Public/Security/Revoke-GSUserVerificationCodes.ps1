function Revoke-GSUserVerificationCodes {
    <#
    .SYNOPSIS
    Revokes/invalidates Verification Codes for the user
    
    .DESCRIPTION
    Revokes/invalidates Verification Codes for the user
    
    .PARAMETER User
    The user to revoke verification codes from
    
    .EXAMPLE
    Revoke-GSUserVerificationCodes -User me -Confirm:$false

    Invalidates the verification codes for the AdminEmail user, skipping confirmation
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
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
                Write-Verbose "Invalidating verification codes for user '$U'"
                $request = $service.VerificationCodes.Invalidate($U)
                $request.Execute()
                Write-Verbose "Verification codes successfully invalidated for user '$U'"
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