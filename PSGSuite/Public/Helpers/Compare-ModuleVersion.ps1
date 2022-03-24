function Compare-ModuleVersion {
    <#
    .SYNOPSIS
    Compares the installed version of a module with the latest version on the PowerShell Gallery

    .DESCRIPTION
    Compares the installed version of a module with the latest version on the PowerShell Gallery

    .PARAMETER ModuleName
    The name of the module to compare

    .EXAMPLE
    Compare-ModuleVersion PSGSuite
    #>
    [CmdletBinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0)]
        [String[]]
        $ModuleName = 'PSGSuite'
    )
    Begin {
        $results = New-Object System.Collections.ArrayList
    }
    Process {
        foreach ($module in $ModuleName) {
            Write-Verbose "Comparing module versions for module '$module'"
            $result = [PSCustomObject][Ordered]@{
                ModuleName       = $module
                InstalledVersion = $null
                GalleryVersion   = $null
                UpdateAvailable  = $null
            }
            if ($InstalledVersion = ((Get-Module -Name $module -ListAvailable).Version | Sort-Object)[-1]) {
                $result.InstalledVersion = $InstalledVersion
                $uri = [Uri]"https://www.powershellgallery.com/api/v2/Packages?`$filter=Id eq '$($module)' and IsLatestVersion"
                if ($GalleryVersion = [System.Version]((Invoke-RestMethod -Uri $uri -Verbose:$false).properties.Version)) {
                    $result.GalleryVersion = $GalleryVersion
                    $result.UpdateAvailable = if ($InstalledVersion -ge $GalleryVersion) {
                        $false
                    }
                    else {
                        $true
                    }
                }
            }
            else {
                Write-Warning "Module '$module' was not found on this machine; unable to compare module versions."
            }
            [void]$results.Add($result)
        }
    }
    End {
        return $results
    }
}
