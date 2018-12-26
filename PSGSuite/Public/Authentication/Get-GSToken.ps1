function Get-GSToken {
    <#
    .Synopsis
    Requests an Access Token for REST API authentication. Defaults to 3600 seconds token expiration time.

    .DESCRIPTION
    Requests an Access Token for REST API authentication. Defaults to 3600 seconds token expiration time.

    .EXAMPLE
    $Token = Get-GSToken -Scopes 'https://www.google.com/m8/feeds' -AdminEmail $User
    $headers = @{
        Authorization = "Bearer $($Token)"
        'GData-Version' = '3.0'
    }
    #>
    Param
    (
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
