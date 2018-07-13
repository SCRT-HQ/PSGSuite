function Get-GSChatWebhook {
    <#
    .SYNOPSIS
    Gets a named Chat Webhook from the PSGSuite config to use with Send-GSChatMessage via REST API

    .DESCRIPTION
    Gets a named Chat Webhook from the PSGSuite config to use with Send-GSChatMessage via REST API

    .EXAMPLE
    Send-GSChatMessage -Text "Testing webhook" -Webhook (Get-GSChatWebhook MyRoom)
    
    Sends a Chat message with text to the Webhook Url named 'MyRoom' found in the config
    #>
    [CmdletBinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [String[]]
        $Name,
        [parameter(Mandatory = $false,Position = 1)]
        [String[]]
        $ConfigName
    )
    if ($PSBoundParameters.Keys -contains 'ConfigName') {
        $currentConfig = Get-PSGSuiteConfig -ConfigName $ConfigName -PassThru -NoImport
    }
    else {
        $currentConfig = Show-PSGSuiteConfig
    }
    foreach ($hook in $Name) {
        Write-Verbose "Getting webhook for '$hook' from ConfigName '$($currentConfig.ConfigName)'"
        if ($found = $currentConfig.Webhook[$hook]) {
            $found
        }
        else {
            Write-Error "$hook was not found in the Webhook dictionary stored in ConfigName '$($currentConfig.ConfigName)'!"
        }
    }
}