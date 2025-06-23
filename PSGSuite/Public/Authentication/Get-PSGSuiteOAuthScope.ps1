Function Get-PSGSuiteOAuthScope {
    <#
    .SYNOPSIS
    Returns the OAuth scopes used by PSGSuite

    .DESCRIPTION
    Returns the OAuth scopes used by PSGSuite
    
    .OUTPUTS
    [PSObject[]]

    By default each result is returned as a PSObject that contains the following properties:
      - Function  - PSGSuite function that uses the scope
      - Service   - API service that owns the scope
      - Scope     - Scope value

    .OUTPUTS
    [String[]]
    
    It is possible to return the list of unique scope values by using the -ValueOnly parameter

    .PARAMETER Scope
    Filters the output for the specified scope

    .PARAMETER Service
    Filters the output for the specified service

    .PARAMETER Function
    Filters the output for the specified function

    .PARAMETER ValueOnly
    Returns the unique scope values only

    .EXAMPLE
    PS > Get-PSGSuiteOAuthScope -Service Google.Apis.Slides.v1.SlidesService

    Function            Service                             Scope
    --------            -------                             -----
    Get-GSPresentation  Google.Apis.Slides.v1.SlidesService https://www.googleapis.com/auth/drive
    Edit-GSPresentation Google.Apis.Slides.v1.SlidesService https://www.googleapis.com/auth/drive

    .EXAMPLE
    PS > Get-PSGSuiteOAuthScope -Function 'Get-GSUser' -ValueOnly

    https://www.googleapis.com/auth/admin.directory.user
    https://www.googleapis.com/auth/admin.directory.user.readonly

    .EXAMPLE
    PS > Get-PSGSuiteOAuthScope -Scope https://www.googleapis.com/auth/chat.bot

    Function             Service                                         Scope
    --------             -------                                         -----
    Send-GSChatMessage   Google.Apis.HangoutsChat.v1.HangoutsChatService https://www.googleapis.com/auth/chat.bot
    Get-GSChatMessage    Google.Apis.HangoutsChat.v1.HangoutsChatService https://www.googleapis.com/auth/chat.bot
    Remove-GSChatMessage Google.Apis.HangoutsChat.v1.HangoutsChatService https://www.googleapis.com/auth/chat.bot
    Get-GSChatSpace      Google.Apis.HangoutsChat.v1.HangoutsChatService https://www.googleapis.com/auth/chat.bot
    Update-GSChatMessage Google.Apis.HangoutsChat.v1.HangoutsChatService https://www.googleapis.com/auth/chat.bot
    Get-GSChatMember     Google.Apis.HangoutsChat.v1.HangoutsChatService https://www.googleapis.com/auth/chat.bot

    .LINK
    https://psgsuite.io/Function%20Help/Authentication/Get-PSGSuiteOAuthScope/

    .LINK
    https://developers.google.com/identity/protocols/oauth2/scopes

    #>
    
    [CmdletBinding(DefaultParameterSetName='GetAll')]
    [OutputType([Object[]])]
    param(
        [Parameter(Mandatory=$true, ParameterSetName='GetService')]
        [ValidateSet([PSGSuiteValidServiceValues])]
        [String]$Service,

        [Parameter(Mandatory=$true, ParameterSetName='GetFunction')]
        [ValidateSet([PSGSuiteValidFunctionValues])]
        [String]$Function,

        [Parameter(Mandatory=$true, ParameterSetName='GetScope')]
        [ValidateSet([PSGSuiteValidOAuthScopeValues])]
        [String]$Scope,
        
        [Parameter(Mandatory=$false, ParameterSetName='GetAll')]
        [Parameter(Mandatory=$false, ParameterSetName='GetService')]
        [Parameter(Mandatory=$false, ParameterSetName='GetFunction')]
        [Parameter(Mandatory=$false, ParameterSetName='GetScope')]
        [Switch]$ValueOnly
    )

    begin {
        If (-not $Script:_PSGSuiteOAuthScopes){
            $PSCmdlet.ThrowTerminatingError((ThrowTerm "The PSGSuite scopes were not found"))
        }
    }

    process {
        
        Switch ($PSCmdlet.ParameterSetName){
            
            'GetService' {
                If ($ValueOnly){
                    Write-Verbose "Getting all unique scope values objects for service '$Service'"
                    $script:_PSGSuiteOAuthScopes | Where-Object {$_.Service -eq $Service} | Select-Object -ExpandProperty 'Scope' -Unique
                } else {
                    Write-Verbose "Getting all scope objects for service '$Service'"
                    $script:_PSGSuiteOAuthScopes | Where-Object {$_.Service -eq $Service} | ForEach-Object {
                        $_.psobject.Copy()
                    }
                }
            }

            'GetFunction' {
                If ($ValueOnly){
                    Write-Verbose "Getting all unique scope values for function '$Function'"
                    $script:_PSGSuiteOAuthScopes | Where-Object {$_.Function -eq $Function} | Select-Object -ExpandProperty 'Scope' -Unique
                } else {
                    Write-Verbose "Getting all scope objects for function '$Function'"
                    $script:_PSGSuiteOAuthScopes | Where-Object {$_.Function -eq $Function} | ForEach-Object {
                        $_.psobject.Copy()
                    }
                }
            }

            'GetScope' {
                If ($ValueOnly){
                    Write-Verbose "Getting all unique scope values for scope '$Scope'"
                    $script:_PSGSuiteOAuthScopes | Where-Object {$_.Scope -eq $Scope} | Select-Object -ExpandProperty 'Scope' -Unique
                } else {
                    Write-Verbose "Getting all scope objects for scope '$Scope'"
                    $script:_PSGSuiteOAuthScopes | Where-Object {$_.Scope -eq $Scope} | ForEach-Object {
                        $_.psobject.Copy()
                    }
                }
            }

            'GetAll' {
                If ($ValueOnly){
                    Write-Verbose "Getting all unique scope values"
                    $script:_PSGSuiteOAuthScopes | Select-Object -ExpandProperty 'Scope' -Unique
                } else {
                    Write-Verbose "Getting all scope objects"
                    $script:_PSGSuiteOAuthScopes | ForEach-Object {
                        $_.psobject.Copy()
                    }
                }
            }

        }

    }

}