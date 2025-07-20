Function Get-PSGSuiteAuthenticationMethod {
    <#
    .SYNOPSIS
    Returns the authentication method that will be used based on the values that have been provided in the PSGSuite configuration.

    .DESCRIPTION
    Returns the authentication method that will be used based on the values that have been provided in the PSGSuite configuration.

    If multiple authentication methods are present in the PSGSuite configuration. The authentication method will be selected based on the following priority order:
    1. Service-Account-JSON-Key
    2. Service-Account-P12-Key
    3. Client-Secrets-OAuth

    The following values can be returned:
    - Service-Account-JSON-Key
    - Service-Account-P12-Key
    - Client-Secrets-OAuth
    - Unknown

    .EXAMPLE
    PS > Get-PSGSuiteAuthenticationMethod

    Service-Account-P12-Key

    .LINK
    https://psgsuite.io/Function%20Help/Authentication/Get-PSGSuiteAuthenticationMethod/
    #>
    [OutputType([String])]
    [cmdletbinding()]
    Param()

    Process {
        if ($script:PSGSuite.JSONServiceAccountKey -or $script:PSGSuite.JSONServiceAccountKeyPath){
            $Method = 'Service-Account-JSON-Key'
        } elseif ($script:PSGSuite.P12KeyPath -or $script:PSGSuite.P12Key -or $script:PSGSuite.P12KeyObject) {
            $Method = 'Service-Account-P12-Key'
        } elseif ($script:PSGSuite.ClientSecretsPath -or $script:PSGSuite.ClientSecrets) {
            $Method = 'Client-Secrets-OAuth'
        } else {
            $Method = 'Unknown'
        }
        Write-Verbose "The current PSGSuite authentication method is '$Method'"
        Return $Method
    }

}