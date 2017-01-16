function Switch-PSGSuiteDomain {
    Param
    (
      [parameter(Mandatory=$true,Position=0)]
      [ValidateNotNullOrEmpty()]
      [String]
      $Domain,
      [parameter(Mandatory=$false)]
      [switch]
      $SetToDefault
    )
Write-Verbose "Switching active domain to $Domain"
$env:PSGSuiteDefaultDomain = $Domain
if ($SetToDefault)
    {
    Write-Verbose "Setting $Domain as the default GSuite domain for future sessions"
    [Environment]::SetEnvironmentVariable("PSGSuiteDefaultDomain", "$Domain", "User")
    }
$Script:PSGSuite = Get-PSGSuiteConfig -Source "PSGSuite.xml" -ErrorAction Stop
}