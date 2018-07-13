function Get-GSChatConfig {
    <#
    .SYNOPSIS
    Returns the specified Chat space and webhook dictionaries from the PSGSuite config to use with Send-GSChatMessage

    .DESCRIPTION
    Returns the specified Chat space and webhook dictionaries from the PSGSuite config to use with Send-GSChatMessage

    .PARAMETER WebhookName
    The key that the Webhook Url is stored as in the Config. If left blank, returns the full Chat configuration from the Config

    .PARAMETER SpaceName
    The key that the Space ID is stored as in the Config. If left blank, returns the full Chat configuration from the Config

    .PARAMETER ConfigName
    The name of the Config to return the Chat config items from

    .EXAMPLE
    Send-GSChatMessage -Text "Testing webhook" -Webhook (Get-GSChatConfig MyRoom)
    
    Sends a Chat message with text to the Webhook Url named 'MyRoom' found in the config
    #>
    [CmdletBinding(DefaultParameterSetName = "Webhooks")]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ParameterSetName = "Webhooks")]
        [String[]]
        $WebhookName,
        [parameter(Mandatory = $false,Position = 0,ParameterSetName = "Spaces")]
        [String[]]
        $SpaceName,
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
    switch ($PSCmdlet.ParameterSetName) {
        Webhooks {
            if ($PSBoundParameters.Keys -contains 'WebhookName') {
                foreach ($hook in $WebhookName) {
                    Write-Verbose "Getting webhook for '$hook' from ConfigName '$($currentConfig.ConfigName)'"
                    if ($found = $currentConfig.Chat['Webhooks'][$hook]) {
                        $found
                    }
                    else {
                        Write-Error "$hook was not found in the Webhook dictionary stored in ConfigName '$($currentConfig.ConfigName)'!"
                    }
                }
            }
            else {
                Write-Verbose "Getting full Chat config from ConfigName '$($currentConfig.ConfigName)'"
                $currentConfig.Chat
            }
        }
        Spaces {
            foreach ($hook in $SpaceName) {
                Write-Verbose "Getting space Id for '$hook' from ConfigName '$($currentConfig.ConfigName)'"
                if ($found = $currentConfig.Chat['Spaces'][$hook]) {
                    $found
                }
                else {
                    Write-Error "$hook was not found in the Spaces dictionary stored in ConfigName '$($currentConfig.ConfigName)'!"
                }
            }
        }
    }
}