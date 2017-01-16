function Set-PSGSuiteDefaultDomain {
    Param
    (
      [parameter(Mandatory=$true,Position=0)]
      [ValidateNotNullOrEmpty()]
      [String]
      $Domain
    )
if ($Domain -ne $env:PSGSuiteDefaultDomain)
    {
    Write-Verbose "Setting default GSuite domain to '$Domain'"
    [Environment]::SetEnvironmentVariable("PSGSuiteDefaultDomain", "$Domain", "User")
    $env:PSGSuiteDefaultDomain = $Domain
    }
else
    {
    Write-Warning "Default GSuite domain is already set to '$Domain'"
    }
}