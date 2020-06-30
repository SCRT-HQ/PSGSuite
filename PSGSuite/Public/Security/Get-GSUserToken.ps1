function Get-GSUserToken {
    <#
    .SYNOPSIS
    Gets security tokens for a user

    .DESCRIPTION
    Gets security tokens for a user

    .PARAMETER User
    The primary email or UserID of the user who you are trying to get info for. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

    Defaults to the AdminEmail in the config

    .PARAMETER ClientId
    The Id of the client you are trying to get token info for. If excluded, gets the full list of tokens for the user

    .EXAMPLE
    Get-GSUserToken -ClientId "Google Chrome"

    Gets the token info for "Google Chrome" for the AdminEmail user
    #>
    [OutputType('Google.Apis.Admin.Directory.directory_v1.Data.Token')]
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
    Process {
        if ($PSBoundParameters.Keys -contains 'ClientId') {
            $serviceParams = @{
                Scope       = 'https://www.googleapis.com/auth/admin.directory.user.security'
                ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
            }
            $service = New-GoogleService @serviceParams
        }
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
                    $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $U -PassThru
                }
                else {
                    $PSBoundParameters['User'] = $U
                    Get-GSUserTokenListPrivate @PSBoundParameters
                }
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
