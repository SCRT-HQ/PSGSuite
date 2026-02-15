Function Resolve-GSChromePolicy {

    <#
    .SYNOPSIS
    Gets the resolved policy values for a list of policies that match a search query.

    .DESCRIPTION
    Gets the resolved policy values for a list of policies that match a search query.

    .PARAMETER OrgUnitID
    The ID or list of IDs of organizational units for which applied policies are to be resolved.

    .PARAMETER Namespace
    The namespace or list of namespaces from which policy values are to be resolved.

    .PARAMETER Schema
    The schema or list of schemas from which policy values are to be resolved.

    .PARAMETER AppID
    The ID or list of IDs of applications for which policy values are to be resolved.

    An appID is formed by combining the app type and app identifier. For example:
    - `chrome:mkaakpdehdafacodkgkpghoibnmamcme` represents the "Google Drawings" Chrome App
    - `android:com.google.android.calendar` represents the "Google Calendar" Android app
    - `web:https://canvas.apps.chrome` represents the "Canvas" Web app

    See notes for further information about target keys.

    .PARAMETER NetworkID
    The ID or list of IDs of networks for which policy values are to be resolved.

    NetworkID values can be found in the Google Admin Console, or by omitting this parameter to return all configured instances.

    See notes for further information about target keys.

    .PARAMETER PrinterID
    The ID or list of IDs of printers for which policy values are to be resolved.

    PrinterID values can be found in the Google Admin Console, or by omitting this parameter to return all configured instances.

    See notes for further information about target keys.

    .PARAMETER PrintServerID
    The ID or list of IDs of print servers for which policy values are to be resolved.

    PrintServerID values can be found in the Google Admin Console, or by omitting this parameter to return all configured instances.

    See notes for further information about target keys.

    .PARAMETER TargetResource
    The target resource on which the resolved policy is applied. The following resources are supported:

    - Organizational Unit = 'orgunits/$orgunitId'
    - Group - 'groups/$groupId'

    .PARAMETER SchemaFilter
    The schema filter, or list of schema filters from which policy values are to be resolved.

    Specify a schema name to view a particular schema, for example: chrome.users.ShowLogoutButton

    Wildcards are supported, but only in the leaf portion of the schema name. Wildcards cannot be used in namespace directly.

    .PARAMETER TargetKey
    Specifies the target keys used to select specific instances of a schema or namespace. Target Keys are supported only where a schema contains a `additionalTargetKeyNames` section.

    Input is provided as one or more hashtables where key = Key_type and value = target_value.

    For Example: @{'app_id' = 'chrome:mkaakpdehdafacodkgkpghoibnmamcme'}
    
    If no target key is provided, all schemas matching the SchemaFilter will be returned.

    See notes for further information about target keys.

    .PARAMETER Raw
    If $true, returns the raw response, otherwise, returns a flattened response for readability.

    .PARAMETER PageSize
    The maximum number of results to return with each request to the API, defaults to 200 and has a maximum of 1000.

    .PARAMETER Limit
    The maximum amount of results you want returned. Exclude or set to 0 to return all results.

    .NOTES
    A schema's name is its unique identifier, with the following format: `{namespace}.{leafName}`

    For example, given the full schema name of `chrome.users.ShowLogoutButton`. The namespace is `chrome.users` and the leaf name is `ShowLogoutButton`.

    Each schema contains one or more fields where each field represents a single Chrome configuration policy. The field name matches the configuration policy name shown in the Google Admin Console.

    In the above example, the `chrome.users.ShowLogoutButton` schema contains a single field for the configuration policy 'ShowLogoutButtonInTray'.

    Target keys are used to identify specific instances of a configuration schema for items:
    
    - Apps
    - Networks
    - Printers
    - Print Servers

    Target Keys are supported only where a schema contains an `additionalTargetKeyNames` section. The following namespaces support target keys and accept keys of the specified type:

    - chrome.devices.kiosk.apps - app_id
    - chrome.devices.managedguest.apps - app_id
    - chrome.networks.cellular - network_id
    - chrome.networks.certificates - network_id
    - chrome.networks.ethernet - network_id
    - chrome.networks.vpn - network_id
    - chrome.networks.wifi - network_id
    - chrome.printers - printer_id
    - chrome.printservers - print_server_id
    - chrome.users.apps - app_id

    .EXAMPLE

    #>

    [CmdletBinding()]
    Param(

        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.Namespace.OrgUnit")]
        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.Schema.OrgUnit")]
        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.App.Namespace.OrgUnit")]
        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.App.Schema.OrgUnit")]
        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.Network.Namespace.OrgUnit")]
        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.Network.Schema.OrgUnit")]
        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.Printer.Namespace.OrgUnit")]
        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.Printer.Schema.OrgUnit")]
        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.PrintServer.Namespace.OrgUnit")]
        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.PrintServer.Schema.OrgUnit")]
        [String]$OrgUnitID,


        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.Namespace.OrgUnit")]
        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.App.Namespace.OrgUnit")]
        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.Network.Namespace.OrgUnit")]
        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.Printer.Namespace.OrgUnit")]
        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.PrintServer.Namespace.OrgUnit")]
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

        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.Schema.OrgUnit")]
        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.App.Schema.OrgUnit")]
        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.Network.Schema.OrgUnit")]
        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.Printer.Schema.OrgUnit")]
        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.PrintServer.Schema.OrgUnit")]
        [String[]]$Schema,


        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.App.Namespace.OrgUnit")]
        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.App.Schema.OrgUnit")]
        [String[]]$AppID,

        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.Network.Namespace.OrgUnit")]
        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.Network.Schema.OrgUnit")]
        [String[]]$NetworkID,

        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.Printer.Namespace.OrgUnit")]
        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.Printer.Schema.OrgUnit")]
        [String[]]$PrinterID,

        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.PrintServer.Namespace.OrgUnit")]
        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.PrintServer.Schema.OrgUnit")]
        [String[]]$PrintServerID,


        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.Advanced")]
        [String[]]$SchemaFilter,

        [Parameter(Mandatory = $True, ParameterSetName = "Resolve.Advanced")]
        [String[]]$TargetResource,

        [Parameter(Mandatory = $False, ParameterSetName = "Resolve.Advanced")]
        [Hashtable[]]$TargetKey,

        [Parameter(Mandatory = $False)]
        [Switch]$Raw,

        [Parameter(Mandatory = $False)]
        [ValidateRange(1,1000)]
        [Int]$PageSize = 200,

        [Parameter(Mandatory = $False)]
        [Int]$Limit = 0

    )

    Process {

        Write-Verbose "Preparing to resolve Chrome policy values"

        # Prepare target resources
        $TargetResources = @()
        Switch -Regex ($PSCmdlet.ParameterSetName){
            '\.OrgUnit$' {
                ForEach ($Entry in $OrgUnitID){
                    $TargetResources += "orgunits/$Entry"
                }
            }
            '\.Group$' {
                ForEach ($Entry in $GroupID){
                    $TargetResources += "groups/$Entry"
                }
            }
            '^Resolve\.Advanced$' {
                ForEach ($Entry in $TargetResource){
                    $TargetResources += "groups/$Entry"
                }
            }
            
        }

        # Prepare schema filters
        $SchemaFilters = @()
        Switch -Regex ($PSCmdlet.ParameterSetName){
            '\.Schema\.' {
                ForEach ($Entry in $Schema){
                    $SchemaFilters += $Entry
                }
            }
            '\.Namespace\.' {
                ForEach ($Entry in $Namespace){
                    $SchemaFilters += "$Entry.*"
                }
            }
            '^Resolve\.Advanced$' {
                ForEach ($Entry in $SchemaFilter){
                    $SchemaFilters += $Entry
                }
            }
        }
        
        # Prepare Target Keys and validate the selected SchemaFilters
        $TargetKeys = @()
        $IncompatibleSchemaFilters = @()
        Switch -Wildcard ($PSCmdlet.ParameterSetName){

            '*App*' {
                ForEach ($Entry in $AppID){
                    $TargetKeys += @{'app_id' = $Entry}
                }
                $IncompatibleSchemaFilters += $SchemaFilters | Where-Object {$_ -notmatch '^(chrome\.users\.|chrome\.devices\.(kiosk|managedguest)\.)apps\.'}
            }
            '*Network*' {
                ForEach ($Entry in $NetworkID){
                    $TargetKeys += @{'network_id' = $Entry}
                }
                $IncompatibleSchemaFilters += $SchemaFilters | Where-Object {$_ -notmatch '^chrome\.networks\.'}
            }
            '*Printer*' {
                ForEach ($Entry in $PrinterID){
                    $TargetKeys += @{'printer_id' = $Entry}
                }
                $IncompatibleSchemaFilters += $SchemaFilters | Where-Object {$_ -notmatch '^chrome\.printers\.'}
            }
            '*PrintServer*' {
                ForEach ($Entry in $PrintServerID){
                    $TargetKeys += @{'print_server_id' = $Entry}
                }
                $IncompatibleSchemaFilters += $SchemaFilters | Where-Object {$_ -notmatch '^chrome\.printservers\.'}
            }
            '*Custom*' {
                # No validation on custom target key values
                If ($TargetKey.count){
                    ForEach ($Entry in $TargetKey){
                        $TargetKeys += @{'print_server_id' = $Entry}
                    }
                } else {
                    # $null is used as a placeholder to allow the RequestTargetKey loop to iterate
                    $TargetKeys += $null
                }
            }
            Default {
                # $null is used as a placeholder to allow the RequestTargetKey loop to iterate
                $TargetKeys += $null
            }
            
        }

        # If incompatibleSchemas were found, throw an error.
        If ($IncompatibleSchemaFilters.count){
            $SchemaString = $SchemaFilters -join "', '"
            $ResourceString = $TargetResources -join "', '"
            $TargetKeyType = $($TargetKeys[0].keys)
            $TargetKeyString = $TargetKeys -join "' }, @{'$TargetKeyType' = '"
            $SubstituteCommand = "Resolve-GSChromePolicy -TargetResource '$ResourceString' -SchemaFilter '$SchemaString' -TargetKey @{'$TargetKeyType' = '$TargetKeyString'}"
            $PSCmdlet.ThrowTerminatingError("The selected schemas do not support target keys based on app_id. The incompatible schemas are:`n$($IncompatibleSchemas -join "`n")`n`n To proceed with the request, use the following command:`n$SubstituteCommand")
        }

        # API Service
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/chrome.management.policy.readonly'
            ServiceType = 'Google.Apis.ChromePolicy.v1.ChromePolicyService'
        }
        $service = New-GoogleService @serviceParams

        # Customer ID
        $CustomerId = Resolve-GSCustomer

        Write-Verbose "$($TargetResources.count) target resources, $($SchemaFilters.count) schema filters and $($TargetKeys.count) target keys were provided. $($TargetResources.Count * $SchemaFilters.Count * $TargetKeys.count) unique requests are required."
        
        ForEach ($RequestTargetResource in $TargetResources){

            ForEach ($RequestSchemaFilter in $SchemaFilters){

                ForEach ($RequestTargetKey in $TargetKeys){

                    If ($RequestTargetKey){
                        Write-Verbose "Resolving Chrome policy values for resource '$RequestTargetResource' from schema '$RequestSchemaFilter' with target key '$RequestTargetKey'"
                    } else {
                        Write-Verbose "Resolving Chrome policy values for resource '$RequestTargetResource' from schema '$RequestSchemaFilter'"
                    }

                    Try {

                        $Body = [Google.Apis.ChromePolicy.v1.Data.GoogleChromePolicyVersionsV1ResolveRequest]::New()
                        $Body.PolicySchemaFilter = $RequestSchemaFilter
                        $PolicyTargetKey = [Google.Apis.ChromePolicy.v1.Data.GoogleChromePolicyVersionsV1PolicyTargetKey]::New()
                        $PolicyTargetKey.TargetResource = $RequestTargetResource
                        $PolicyTargetKey.AdditionalTargetKeys = $RequestTargetKey
                        $Body.PolicyTargetKey = $PolicyTargetKey
                        $Request = $Service.Customers.Policies.Resolve($Body, "customers/$CustomerID")

                        If ($Raw){
                            Invoke-GSPaginatedRequest -Request $Request -Body $Body -PageSize $PageSize -Limit $Limit
                        } else {

                            # Format the response as a flattened object for readability
                            Invoke-GSPaginatedRequest -Request $Request -Body $Body -PageSize $PageSize -Limit $Limit | ForEach-Object {
                                
                                

                                [PSCustomObject]@{
                                    TargetResource = $_.TargetKey.TargetResource
                                    SourceResource = $_.SourceKey.TargetResource
                                    State = ''
                                    TargetKey = $_.TargetKey.AdditionalTargetKeys
                                    Schema = $_.value.policySchema
                                    Value = $_.value.value
                                }
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

}