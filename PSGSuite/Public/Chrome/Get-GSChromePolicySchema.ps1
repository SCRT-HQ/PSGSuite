Function Get-GSChromePolicySchema {

    <#
    .SYNOPSIS
    Gets the schema for the specified Chrome policies. Returns the schema for all policies if -Name is excluded.

    .DESCRIPTION
    Gets the schema for the specified Chrome policies. Returns the schema for all policies if -Name is excluded.

    .NOTES
    It is possible to access the schema for policies that are available in the Google Admin Console only. If a policy is not available in the Google Admin Console, it cannot be queried with this function.

    Each schema represents a single setting from the Google Admin Console, where the schema's `policyDescription` field often matches the name of the setting.

    A schema's name is its unique identifier, with the following format: `{namespace}.{leafName}`

    A schema contains one or more fields where each field represents a single Chrome configuration policy. The field name often matches the `Chromium name` of each setting that is shown in the Google Admin Console.

    For example, the Google Admin Console user setting `Show sign-out button in tray` is represented by a Schema with the following values:
      - Schema name: `chrome.users.ShowLogoutButton`
      - Namespace: `chrome.users`
      - Leaf name: `ShowLogoutButton`
      - Contains a field with name: `ShowLogoutButtonInTray`
      - Policy description: `Show sign-out button in tray.`


    .PARAMETER Name
    The schema or list of schemas for which details should be retrieved. If excluded, all schemas are returned.

    .PARAMETER Namespace
    The namespace or list of namespaces for which schemas should be retrieved.

    Complete namespace documentation is found here: https://developers.google.com/chrome/policy/guides/policy-schemas
    
    .PARAMETER Field
    Returns the schemas with field names that match the value or list of values provided.

    Field names often match the 'Chromium name' values that are shown in the Google Admin Console.

    .PARAMETER Description
    Returns the schemas with policy descriptions that contain the value or list of values provided.

    Policy descriptions often match the setting name that is shown in the Google Admin Console.

    .PARAMETER Filter
    The schema filter used to find a particular schema based on fields like its resource name, description and additionalTargetKeyNames. Complete filter syntax can be found here: https://developers.google.com/chrome/policy/guides/list-policy-schemas

    .PARAMETER Raw
    If $true, returns the raw response, otherwise, returns a flattened response for readability.

    .PARAMETER PageSize
    The maximum number of results to return with each request to the API, defaults to 200 and has a maximum of 1000.

    .PARAMETER Limit
    The maximum amount of results you want returned. Exclude or set to 0 to return all results.

    .EXAMPLE
    PS > Get-GSChromePolicySchema

    Returns the schema for all policies.

    .EXAMPLE
    PS > Get-GSChromePolicySchema -Namespace chrome.users

    Returns the schema for all policies from the `chrome.users` namespace.

    .EXAMPLE
    PS > Get-GSChromePolicySchema -Name chrome.users.ShowLogoutButton

    Returns the `chrome.users.ShowLogoutButton` schema.

    .EXAMPLE
    PS > Get-GSChromePolicySchema -Field ShowLogoutButtonInTray

    Returns the `chrome.users.ShowLogoutButton` and `chrome.devices.managedguest.ShowLogoutButton` schemas which both contain a field with the name `ShowLogoutButtonInTray`.

    .EXAMPLE
    PS > Get-GSChromePolicySchema -Description 'Show sign-out button'

    Returns the `chrome.users.ShowLogoutButton` and `chrome.devices.managedguest.ShowLogoutButton` schemas which both contain the `ShowLogoutButtonInTray`.


    .LINK
    https://psgsuite.io/Function%20Help/Chrome/Get-GSChromePolicySchema/

    .LINK
    https://developers.google.com/chrome/policy/guides/policy-schemas

    .LINK
    https://developers.google.com/chrome/policy/reference/rest/v1/customers.policySchemas

    .LINK
    https://chromeenterprise.google/policies/

    #>

    [CmdletBinding(DefaultParameterSetName = 'List.All')]
    [OutputType('Google.Apis.ChromePolicy.v1.Data.GoogleChromePolicyVersionsV1PolicySchema')]
    Param(

        [Parameter(Mandatory = $True, ParameterSetName = 'Get')]
        [Alias('Schema')]
        [String[]]$Name,

        [Parameter(Mandatory = $True, ParameterSetName = 'List.Namespace')]
        [ArgumentCompletions(
            'chrome.devices',
            'chrome.devices.kiosk',
            'chrome.devices.kiosk.apps',
            'chrome.devices.kiosk.appsconfig',
            'chrome.devices.managedguest',
            'chrome.devices.managedguest.apps',
            'chrome.networks.cellular',
            'chrome.networks.certificates',
            'chrome.networks.ethernet',
            'chrome.networks.globalsettings',
            'chrome.networks.vpn',
            'chrome.networks.wifi',
            'chrome.printers',
            'chrome.printservers',
            'chrome.users',
            'chrome.users.apps',
            'chrome.users.appsconfig'
        )]
        [String[]]$Namespace,
        
        [Parameter(Mandatory = $True, ParameterSetName = 'List.Field')]
        [Alias('ChromiumName', 'OnDevicePolicyName', 'Policy')]
        [String[]]$Field,

        [Parameter(Mandatory = $True, ParameterSetName = 'List.Description')]
        [Alias('Setting')]
        [String[]]$Description,

        [Parameter(Mandatory = $True, ParameterSetName = 'List.Filter')]
        [String]$Filter,

        [Parameter(Mandatory = $False)]
        [Switch]$Raw,

        [Parameter(Mandatory = $False, ParameterSetName = 'List.Field')]
        [Parameter(Mandatory = $False, ParameterSetName = 'List.Namespace')]
        [Parameter(Mandatory = $False, ParameterSetName = 'List.Filter')]
        [Parameter(Mandatory = $False, ParameterSetName = 'List.Description')]
        [ValidateRange(1,1000)]
        [Int]$PageSize = 200,

        [Parameter(Mandatory = $False, ParameterSetName = 'List.Field')]
        [Parameter(Mandatory = $False, ParameterSetName = 'List.Namespace')]
        [Parameter(Mandatory = $False, ParameterSetName = 'List.Filter')]
        [Parameter(Mandatory = $False, ParameterSetName = 'List.Description')]
        [Int]$Limit = 0
    )

    Process {

        $customerId = Resolve-GSCustomer

        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/chrome.management.policy.readonly'
            ServiceType = 'Google.Apis.ChromePolicy.v1.ChromePolicyService'
        }
        $service = New-GoogleService @serviceParams

        Switch -Wildcard ($PSCmdlet.ParameterSetName) {
            
            'Get' {
                
                ForEach ($Entry in $Name){

                    Write-Verbose "Getting Chrome policy schema '$Entry'"
                    Try {

                        $Request = $service.Customers.PolicySchemas.Get("customers/$CustomerID/policySchemas/$Entry")
                        $Request.Execute() | ForEach-Object {
                            If ($Raw){
                                $_
                            } else {
                                Format-GSChromePolicySchema -Schema $_
                            }
                        }

                    } Catch {

                        if ($ErrorActionPreference -eq 'Stop') {
                            $PSCmdlet.ThrowTerminatingError($_)
                        } else {
                            Write-Error $_
                        }

                    }

                }

            }

            'List.*' {

                $VerbString = "Getting all Chrome policy schemas"
                
                $Request = $service.Customers.PolicySchemas.List("customers/$CustomerID")

                Switch ($PSCmdlet.ParameterSetName){
                    
                    'List.Field' {
                        $FilterParts = @()
                        ForEach ($Entry in $Field){
                            $FilterParts += "field_descriptions.field=$Entry"
                        }
                        $Filter = "$($FilterParts -join " OR ")"
                    }

                    'List.Namespace' {
                        $FilterParts = @()
                        ForEach ($Entry in $Namespace){
                            $FilterParts += "namespace=$Entry"
                        }
                        $Filter = "$($FilterParts -join " OR ")"
                    }

                    'List.Description' {
                        $FilterParts = @()
                        ForEach ($Entry in $description){
                            $FilterParts += "description=`"$Entry`""
                        }
                        $Filter = "$($FilterParts -join " OR ")"
                    }

                }
                
                If ($Filter){
                    $VerbString += " matching filter '$filter'"
                    $Request.Filter = $filter
                }

                Write-Verbose $VerbString
                Try {
                    
                    Invoke-GSPaginatedRequest -Request $Request -PageSize $PageSize -Limit $Limit  | ForEach-Object {
                        If ($Raw){
                            $_
                        } else {
                            Format-GSChromePolicySchema -Schema $_
                        }
                    }

                } Catch {

                    if ($ErrorActionPreference -eq 'Stop') {
                        $PSCmdlet.ThrowTerminatingError($_)
                    } else {
                        Write-Error $_
                    }

                }

            }

        }

    }

}