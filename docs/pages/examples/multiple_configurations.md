# Multiple Configurations

PSGSuite 2.0.0 uses a single file configuration stored outside of the module folder. If you intend to use the module with more than one account on the same machine, you will want to create your configuration with an AES key as the encryption method.

To do this you'll want to create a key then pass the key as the first argument when importing the module.

**You must pass `$null` after the key as shown to force the full key to be used, otherwise only the first byte in the array will be passed as the key value**

```powershell
$key = [Byte[]]@(1..16) # Don't actually use something this easy to replicate, this is just an example

Import-Module PSGSuite -ArgumentList $key,$null

$props = @{
    ConfigName             = "client1"
    P12KeyPath             = "C:\P12s\PSGSuite-theirdomain.p12"
    AppEmail               = "psgsuite@theirdomain.iam.gserviceaccount.com"
    AdminEmail             = "admin@theirdomain.io"
    CustomerID             = "C092xxxxxx"
    Domain                 = "theirdomain.io"
    Preference             = "CustomerID"
    ServiceAccountClientID = "12399898494949494994949"
}

Set-PSGSuiteConfig @props
```
