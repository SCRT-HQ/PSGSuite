<#
    This is a quick helper script to get PSGSuite loaded in Debug Mode.
    Debug Mode exports the following additional functions with PSGSuite:
        - Get-GSToken: Used for legacy functions that require calling Google's REST API directly
        - New-GoogleService: Used in all SDK based functions to build out the service client
#>

# Enable Debug Mode to export the New-GoogleService function during module import
# by setting the environment variable '$env:EnablePSGSuiteDebug' to $true
$env:EnablePSGSuiteDebug = $false

Get-Module PSGSuite | Remove-Module -Force

. .\build.ps1 -Task Compile

# Force import the module in the repo path so that updated functions are reloaded
$modulePath = [System.IO.Path]::Combine("$PSScriptRoot","out","PSGSuite")
Import-Module $modulePath -Force

Get-Module PSGSuite | Select-Object Name,Version,ModuleBase
