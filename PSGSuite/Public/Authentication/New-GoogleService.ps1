function New-GoogleService {
    <#
    .SYNOPSIS
    Creates a new Google Service object that handles authentication for the scopes specified

    .DESCRIPTION
    Creates a new Google Service object that handles authentication for the scopes specified

    .PARAMETER Scope
    The scope or scopes to build the service with, e.g. https://www.googleapis.com/auth/admin.reports.audit.readonly

    .PARAMETER ServiceType
    The type of service to create, e.g. Google.Apis.Admin.Reports.reports_v1.ReportsService

    .PARAMETER User
    The user to request the service for during the authentication process

    .EXAMPLE
    $serviceParams = @{
        Scope       = 'https://www.googleapis.com/auth/admin.reports.audit.readonly'
        ServiceType = 'Google.Apis.Admin.Reports.reports_v1.ReportsService'
    }
    $service = New-GoogleService @serviceParams

    .LINK
    https://psgsuite.io/Function%20Help/Authentication/New-GoogleService/
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true,Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Scope,
        [Parameter(Mandatory = $true,Position = 1)]
        [String]
        $ServiceType,
        [Parameter(Mandatory = $false,Position = 2)]
        [Alias('AdminEmail')]
        [String]
        $User = $script:PSGSuite.AdminEmail
    )
    Begin {
        if (-not $script:_PSGSuiteSessions) {
            $script:_PSGSuiteSessions = @{}
        }
        $sessionKey = @($User,$ServiceType,$(($Scope | Sort-Object) -join ";")) -join ";"
    }
    Process {
        if ($script:_PSGSuiteSessions.ContainsKey($sessionKey)) {
            if (-not $script:_PSGSuiteSessions[$sessionKey].Acknowledged) {
                Write-Verbose "Using matching cached service for user '$User'"
                $script:_PSGSuiteSessions[$sessionKey].Acknowledged = $true
            }
            $script:_PSGSuiteSessions[$sessionKey].LastUsed = Get-Date
            $script:_PSGSuiteSessions[$sessionKey] | Select-Object -ExpandProperty Service
        }
        else {

            Try {
                $AuthMethod = Get-PSGSuiteAuthenticationMethod
                Switch ($AuthMethod){
                    'Service-Account-JSON-Key' {
                        $Credential = New-GoogleServiceAccountCredential -Scope $Scope -User $User
                    }
                    'Service-Account-P12-Key' {
                        $Credential = New-GoogleServiceAccountCredential -Scope $Scope -User $User
                    }
                    'Client-Secrets-OAuth' {
                        $Credential = New-GoogleUserCredential -Scope $Scope -User $User
                    }
                    Default {
                        $PSCmdlet.ThrowTerminatingError((ThrowTerm "The current config '$($script:PSGSuite.ConfigName)' does not contain a JSONServiceAccountKeyPath, P12KeyPath, or ClientSecretsPath! PSGSuite is unable to build a credential object for the service without a path to a credential file! Please update the configuration to include a path at least one of the three credential types."))
                    }
                }
            } Catch {
                $PSCmdlet.ThrowTerminatingError($_)
            }

            $svc = New-Object "$ServiceType" (New-Object 'Google.Apis.Services.BaseClientService+Initializer' -Property @{
                    HttpClientInitializer = $credential
                    ApplicationName       = "PSGSuite"
                }
            )
            $script:_PSGSuiteSessions[$sessionKey] = ([PSCustomObject]@{
                User         = $User
                Scope        = $Scope
                Service      = $svc
                Issued       = Get-Date
                LastUsed     = Get-Date
                Acknowledged = $false
            })
            return $svc
        }
    }
}
