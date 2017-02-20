#Get public and private function definition files.
    $Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
    $Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
    $ModuleRoot = $PSScriptRoot

#Dot source the files
Foreach($import in @($Public + $Private))
    {
    Try
        {
        . $import.fullname
        }
    Catch
        {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
        }
    }

if (!$env:PSGSuiteDefaultDomain)
    {
    Write-Host "No default PSGSuite domain set as '" -NoNewline;Write-Host -ForegroundColor Green "`$env:PSGSuiteDefaultDomain" -NoNewline;Write-Host "'!"
    $def = Read-Host "Please enter your default domain name (i.e. 'domain.com' or 'example.net')"
    Set-PSGSuiteDefaultDomain -Domain $def -Verbose
    $env:PSGSuiteDefaultDomain = $def
    }

#Create / Read config
if(-not (Test-Path -Path "$PSScriptRoot\$env:USERNAME-$env:COMPUTERNAME-$env:PSGSuiteDefaultDomain-PSGSuite.xml" -ErrorAction SilentlyContinue))
    {
    $new = $true
    Try
        {
        Write-Host -ForegroundColor Yellow "Creating config file shell at path: $PSScriptRoot\$env:USERNAME-$env:COMPUTERNAME-$env:PSGSuiteDefaultDomain-PSGSuite.xml"
        [pscustomobject]@{
            P12KeyPath = $null
            AppEmail = $null
            AdminEmail = $null
            CustomerID = $null
            Domain = $null
            Preference = $null
            ServiceAccountClientID = $null
            } | Export-Clixml -Path "$PSScriptRoot\$env:USERNAME-$env:COMPUTERNAME-$env:PSGSuiteDefaultDomain-PSGSuite.xml" -Force -ErrorAction Stop
        }
    Catch
        {
        Write-Warning "Failed to create config file $PSScriptRoot\$env:USERNAME-$env:COMPUTERNAME-$env:PSGSuiteDefaultDomain-PSGSuite.xml: $_"
        }
    }
#>

#Initialize the config variable
Try
    {
    #Import the config
    $PSGSuite = $null
    $PSGSuite = Get-PSGSuiteConfig -Source "PSGSuite.xml" -ErrorAction Stop
    }
Catch
    {   
    Write-Warning "Error importing PSGSuite config: $_"
    }
    
Export-ModuleMember -Function $Public.Basename

if($new -eq $true)
    {
    Try
        {
        Write-Host -ForegroundColor Yellow "Please answer the following questions to finish creating your config file. If you do not have the information, you may skip the questions by pressing " -NoNewline;Write-Host -ForegroundColor Green "[ENTER] " -NoNewline;Write-Host -ForegroundColor Yellow "and finish creating the config file later by running " -NoNewline;Write-Host -ForegroundColor Green "Set-PSGSuiteConfig" -NoNewline;Write-Host -ForegroundColor Yellow "."
        $P12KeyPath = Read-Host "`t+ Full path to your P12 key file"
        $AppEmail = Read-Host "`t+ App Email for the Google Service Account"
        $AdminEmail = Read-Host "`t+ Admin Email (SuperAdmin that created the Dev Service Account)"
        $CustomerID = Read-Host "`t+ Customer ID"
        $ServiceAccountClientID = Read-Host "`t+ Service Account Client ID"
        $props = @{
            P12KeyPath = $P12KeyPath
            AppEmail = $AppEmail
            AdminEmail = $AdminEmail
            CustomerID = $CustomerID
            Domain = $env:PSGSuiteDefaultDomain
            Preference = "CustomerID"
            ServiceAccountClientID = $ServiceAccountClientID
            }
        Set-PSGSuiteConfig @props -Verbose
        }
    Catch
        {
        Write-Warning "Failed to create config file $PSScriptRoot\$env:USERNAME-$env:COMPUTERNAME-$env:PSGSuiteDefaultDomain-PSGSuite.xml: $_"
        }
    }