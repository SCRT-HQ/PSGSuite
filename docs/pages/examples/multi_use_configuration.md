# Multi-Use Configuration

PSGSuite 2.0.0 and later uses a single file configuration stored outside of the module folder. The file is normally located in `$env:LOCALAPPDATA\powershell\SCRT HQ\PSGSuite\Configuration.psd1`.

If you intend to use the module with more than one user account on the same machine, you will want to create your configuration with an AES key as the encryption method. To do this you'll want to create a key then pass the key as the first argument when importing the module.

!!! danger
    You **must** pass `$null` after the `$key` argument as shown to force the full key to be used, otherwise only the first byte in the array will be passed as the key value

```powershell {linenums="1"}
$key = [byte[]]::new(32) # 32 bytes for AES-256
[Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($key)

Import-Module PSGSuite -ArgumentList $key,$null

$props = @{
    ConfigName             = 'MyMultiUseConfig'
    P12KeyPath             = '\\path\to\your\p12key.p12'
    AppEmail               = 'service_account_email'
    AdminEmail             = 'admin_email'
    CustomerID             = 'customer_id'
    Domain                 = "domain.com"
    Preference             = "CustomerID"
    ServiceAccountClientID = "service_account_client_id"
}

Set-PSGSuiteConfig @props
```
