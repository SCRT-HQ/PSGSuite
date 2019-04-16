#region: Mock a config and load it for other functions to use
Mock 'Get-PSGSuiteConfig' -ModuleName PSGSuite -MockWith {
    Write-Verbose "Getting mocked PSGSuite config"
    $script:PSGSuite = [PSCustomObject][Ordered]@{
        ConfigName = 'Pester'
        P12KeyPath = ([System.IO.Path]::Combine($PSScriptRoot,"fake.p12"))
        ClientSecretsPath = ([System.IO.Path]::Combine($PSScriptRoot,"fake_client_secrets.json"))
        AppEmail = "mock@iam.gserviceaccount.com"
        AdminEmail = "admin@domain.com"
        CustomerId = 'Cxxxxxxxxx'
        Domain = 'domain.com'
        Preference = 'CustomerID'
        ServiceAccountClientID = '1111111111111111111111111'
    }
}
Get-PSGSuiteConfig -Verbose
#endregion

#region purpose: Base classes
class GoogleRequest {
    [String] $Customer
    [String] $CustomFieldMask
    [String] $Domain
    [String] $Fields
    [String] $Key
    [Int] $MaxResults
    [String] $OauthToken
    [String] $PageToken
    [Bool] $PrettyPrint
    [String] $Query
    [String] $QuotaUser
    [String] $ShowDeleted

    GoogleRequest() {

    }

    [Object[]] Execute() {
        throw "Must Override Method"
    }
    [Object[]] ExecuteAsStream() {
        throw "Must Override Method"
    }
    [Object[]] ExecuteAsStreamAsync() {
        throw "Must Override Method"
    }
    [Object[]] ExecuteAsync() {
        throw "Must Override Method"
    }
}
class GoogleService {
    [String] $APIKey
    [String] $ApplicationName = $null
    [String] $BasePath
    [String] $BaseUri
    [String] $BatchPath
    [String] $BatchUri
    [System.Collections.Generic.List[String]] $Features
    [Bool] $GZipEnabled
    [String] $Name

    GoogleService() {

    }
}
#endregion
