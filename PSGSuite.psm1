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
    Set-PSGSuiteDefaultDomain -Domain "Default"
    $env:PSGSuiteDefaultDomain = "Default"
    }

#Create / Read config
if(-not (Test-Path -Path "$PSScriptRoot\$env:USERNAME-$env:COMPUTERNAME-$env:PSGSuiteDefaultDomain-PSGSuite.xml" -ErrorAction SilentlyContinue))
    {
    Try
        {
        Write-Warning "Did not find config file $PSScriptRoot\$env:USERNAME-$env:COMPUTERNAME-$env:PSGSuiteDefaultDomain-PSGSuite.xml, attempting to create"
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