
$cer = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new($P12KeyPath,"notasecret",[System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)

$credential = New-Object 'Google.Apis.Auth.OAuth2.ServiceAccountCredential' (New-Object 'Google.Apis.Auth.OAuth2.ServiceAccountCredential+Initializer' $AppEmail -Property @{
        User   = $AdminEmail
        Scopes = [string[]]("https://www.googleapis.com/auth/admin.directory.user.readonly")
    }).FromCertificate($cer)

$dirSvc = New-Object 'Google.Apis.Admin.Directory.directory_v1.DirectoryService' (New-Object 'Google.Apis.Services.BaseClientService+Initializer' -Property @{
        HttpClientInitializer = $credential
        ApplicationName       = "PSGSuite - $env:USERNAME"
    })

$user = $dirSvc.Users.Get("n@ferrell.io").Execute()
$user

<#

$com = "URL"
Get-ChildItem .\PSGSuite2\Public\TODO -Filter "*$com*" | Move-Item -Destination .\PSGSuite2\Public\WIP

#>
d
@(
    @{
        ConfigName             = "pnmac"
        P12KeyPath             = "C:\GDrive\GoogleApps\Access\PSGoogle.p12"
        AppEmail               = "psgoogle@nf-gam-project.iam.gserviceaccount.com"
        AdminEmail             = "nathaniel.ferrell@pnmac.com"
        CustomerID             = "C00jnnszb"
        Domain                 = "pnmac.com"
        Preference             = "CustomerID"
        ServiceAccountClientID = "117579888572163351841"
    }
    @{
        ConfigName             = "scrthq"
        P12KeyPath             = "C:\GDrive\GoogleApps\Access\PSGSuite-scrthq.com.p12"
        AppEmail               = "psgsuite@psgsuite.iam.gserviceaccount.com"
        AdminEmail             = "nate@scrthq.com"
        CustomerID             = "C02ojcp58"
        Domain                 = "ferrell.io"
        Preference             = "CustomerID"
        ServiceAccountClientID = "117611319616787661322"
        SetAsDefaultConfig     = $true
    }
) | ForEach-Object {
    $props = $_
    Set-PSGSuiteConfig @props
}