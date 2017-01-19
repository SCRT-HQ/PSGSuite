function Switch-PSGSuiteDomain {
    Param
    (
      [parameter(Mandatory=$true,Position=0)]
      [ValidateNotNullOrEmpty()]
      [String]
      $Domain,
      [parameter(Mandatory=$false)]
      [switch]
      $SetToDefault,
      [parameter(Mandatory=$false)]
      [switch]
      $ShowCommand
    )
if ($Domain -ne $env:PSGSuiteDefaultDomain)
    {
    Write-Verbose "Switching active domain to $Domain"
    $env:PSGSuiteDefaultDomain = $Domain
    if ($SetToDefault)
        {
        Write-Verbose "Setting $Domain as the default GSuite domain for future sessions"
        [Environment]::SetEnvironmentVariable("PSGSuiteDefaultDomain", "$Domain", "User")
        }
    $Script:PSGSuite = Get-PSGSuiteConfig -Source "PSGSuite.xml"
    }
else
    {
    Write-Warning "GSuite domain is already set to '$Domain'"
    }
if ($ShowCommand)
    {
    Write-Host -ForegroundColor Yellow "The command to create this config again is:

Set-PSGSuiteConfig -P12KeyPath `"$($Script:PSGSuite.P12KeyPath)`" -AppEmail `"$($Script:PSGSuite.AppEmail)`" -AdminEmail `"$($Script:PSGSuite.AdminEmail)`" -CustomerID `"$($Script:PSGSuite.CustomerID)`" -Domain `"$($Script:PSGSuite.Domain)`" -Preference `"$($Script:PSGSuite.Preference)`" -ServiceAccountClientID `"$($Script:PSGSuite.ServiceAccountClientID)`""
    }
}