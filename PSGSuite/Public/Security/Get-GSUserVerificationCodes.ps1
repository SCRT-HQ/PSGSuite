function Get-GSUserVerificationCodes {
    <#
    .SYNOPSIS
    Gets the 2-Step Verification Codes for the user

    .DESCRIPTION
    Gets the 2-Step Verification Codes for the user

    .PARAMETER User
    The primary email or UserID of the user who you are trying to get info for. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

    Defaults to the AdminEmail in the config

    .EXAMPLE
    Get-GSUserVerificationCodes

    Gets the Verification Codes for AdminEmail user
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.VerificationCode')]
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
                if ($U -ceq 'me') {
                    $U = $Script:PSGSuite.AdminEmail
                }
                elseif ($U -notlike "*@*.*") {
                    $U = "$($U)@$($Script:PSGSuite.Domain)"
                }
                Write-Verbose "Getting Verification Code list for User '$U'"
                $request = $service.VerificationCodes.List($U)
                $request.Execute() | Select-Object -ExpandProperty Items | Add-Member -MemberType NoteProperty -Name 'User' -Value $U -PassThru
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
