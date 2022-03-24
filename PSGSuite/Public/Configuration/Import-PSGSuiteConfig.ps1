function Import-PSGSuiteConfig {
    <#
    .SYNOPSIS
    Allows you to import an unecrypted PSGSuite config from a portable JSON string format, typically created with Export-PSGSuiteConfig. Can also import directly from a PSCustomObject. Useful for moving a config to a new machine or storing the full as an encrypted string in your CI/CD / Automation tools.

    .DESCRIPTION
    Allows you to import an unecrypted PSGSuite config from a portable JSON string format, typically created with Export-PSGSuiteConfig. Can also import directly from a PSCustomObject. Useful for moving a config to a new machine or storing the full as an encrypted string in your CI/CD / Automation tools.

    .PARAMETER Json
    The Json string to import.

    .PARAMETER Path
    The path of the Json file you would like import.

    .PARAMETER Object
    The PSCustomObject you would like to import

    .PARAMETER Temporary
    If $true, the imported config is not stored in the config file and the imported config persists only for the current session.

    .PARAMETER PassThru
    If $true, outputs the resulting config object to the pipeline.

    .EXAMPLE
    Import-Module PSGSuite -MinimumVersion 2.22.0
    Import-PSGSuiteConfig -Json '$(PSGSuiteConfigJson)' -Temporary

    Azure Pipelines inline script task that uses a Secure Variable named 'PSGSuiteConfigJson' with the Config JSON string stored in it, removing the need to include credential or key files anywhere.

    .EXAMPLE
    [PSCustomObject]$PSGSuiteSettings = [PSCustomObject]@{
        P12KeyObject = Get-AutomationCertificate -name 'gcert.p12'
        AppEmail = Get-AutomationVariable -name 'gappemail'
        AdminEmail = Get-AutomationVariable -name 'gadminemail'
    }
    Import-PSGsuiteConfig -Object $PSGSuiteSettings -Temporary

    Some properties can't be serialized in JSON, this is another way to store secrets in your automation tool (this example shows Azure Automation)
    #>
    [CmdletBinding(DefaultParameterSetName = "Json")]
    Param (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ParameterSetName = "Json")]
        [Alias('J')]
        [String]
        $Json,
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true,ParameterSetName = "Path")]
        [Alias('P')]
        [String]
        $Path,
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true,ParameterSetName = "Object")]
        [Alias('O')]
        [PSCustomObject]
        $Object,
        [parameter(Mandatory = $false)]
        [Alias('Temp','T')]
        [Switch]
        $Temporary,
        [parameter(Mandatory = $false)]
        [Switch]
        $PassThru
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Path {
                    Write-Verbose "Importing config from path: $Path"
                    $script:PSGSuite = (ConvertFrom-Json (Get-Content $Path -Raw)) | Get-GSDecryptedConfig -ConfigName 'ImportPath'
                }
                Json {
                    Write-Verbose "Importing config from Json string"
                    $script:PSGSuite = (ConvertFrom-Json $Json) | Get-GSDecryptedConfig -ConfigName 'ImportJSON'
                }
                Object {
                    Write-Verbose "Importing config from Object"
                    $script:PSGSuite = $Object | Get-GSDecryptedConfig -ConfigName 'ImportObject'
                }
            }
            if (-not $Temporary) {
                Write-Verbose "Saving imported config"
                $script:PSGSuite | Set-PSGSuiteConfig
            }
            if ($PassThru) {
                return $script:PSGSuite
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}
