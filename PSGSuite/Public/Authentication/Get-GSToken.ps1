function Get-GSToken {
    <#
    .SYNOPSIS
    Requests an Access Token for REST API authentication. Defaults to 3600 seconds token expiration time.

    .DESCRIPTION
    Requests an Access Token for REST API authentication. Defaults to 3600 seconds token expiration time.

    .PARAMETER Scopes
    The list of scopes to request the token for

    .PARAMETER AdminEmail
    The email address of the user to request the token for. This is typically the Admin user.

    .EXAMPLE
    $Token = Get-GSToken -Scopes 'https://www.google.com/m8/feeds' -AdminEmail $User
    $headers = @{
        Authorization = "Bearer $($Token)"
        'GData-Version' = '3.0'
    }

    .LINK
    https://psgsuite.io/Function%20Help/Authentication/Get-GSToken/
    #>
    Param (
        [parameter(Mandatory = $true)]
        [Alias('Scope')]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Scopes,
        [parameter(Mandatory = $false)]
        [Alias('User')]
        [ValidateNotNullOrEmpty()]
        [String]
        $AdminEmail = $Script:PSGSuite.AdminEmail
    )
    try {
        Write-Verbose "Acquiring access token"
        $serviceParams = @{
            Scope       = $Scopes
            ServiceType = 'Google.Apis.Gmail.v1.GmailService'
            User        = $AdminEmail
        }
        $service = New-GoogleService @serviceParams
        ($service.HttpClientInitializer.GetAccessTokenForRequestAsync()).Result
    }
    catch {
        Write-Verbose "Failed to acquire access token!"
        $PSCmdlet.ThrowTerminatingError($_)
    }
}
