# Enable Debug Mode to export the New-GoogleService function during module import
# by setting the environment variable '$env:EnablePSGSuiteDebug' to $true
$env:EnablePSGSuiteDebug = $true

# Force import the module in the repo path so that updated functions are reloaded
Import-Module (Join-Path (Join-Path (Join-Path "$PSScriptRoot" "..") "PSGSuite") "PSGSuite.psd1") -Force