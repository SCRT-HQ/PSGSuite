function Set-PSGSuiteDefaultDomain {
    Param
    (
      [parameter(Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [String]
      $Domain
    )
[Environment]::SetEnvironmentVariable("PSGSuiteDefaultDomain", "$Domain", "User")
$env:PSGSuiteDefaultDomain = $Domain
}