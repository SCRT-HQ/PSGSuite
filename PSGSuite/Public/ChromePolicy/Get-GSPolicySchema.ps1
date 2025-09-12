function Get-GSPolicySchema {
    <#
    .SYNOPSIS
    Gets Chrome policy schemas from the Chrome Policy API

    .DESCRIPTION
    Gets Chrome policy schemas that can be applied to Chrome OS devices and Chrome browsers in your organization.

    .PARAMETER SchemaName
    The specific schema name to retrieve. Can be either a full path (e.g., "customers/{customer}/policySchemas/chrome.users.AutoOpenFileTypes") 
    or just the schema name (e.g., "chrome.users.AutoOpenFileTypes"). If not provided, lists all policy schemas.

    .PARAMETER Filter
    Search filter to apply to the policy schemas. Supports filtering by namespace (e.g., "chrome.users.apps").

    .PARAMETER PageSize
    Maximum number of policy schemas to return in a single request. Default is 100.

    .PARAMETER Limit
    Maximum number of policy schemas to return. Set to 0 to return all results.

    .EXAMPLE
    Get-GSPolicySchema

    Gets all Chrome policy schemas for the organization

    .EXAMPLE
    Get-GSPolicySchema -Filter "chrome.users.apps"

    Gets policy schemas related to user applications

    .EXAMPLE
    Get-GSPolicySchema -SchemaName "chrome.users.AutoOpenFileTypes"

    Gets a specific policy schema by name

    .EXAMPLE
    Get-GSPolicySchema -SchemaName "customers/{customer}/policySchemas/chrome.users.AutoOpenFileTypes"

    Gets a specific policy schema using the full path
    #>
    [OutputType('Google.Apis.ChromePolicy.v1.Data.GoogleChromePolicyV1PolicySchema')]
    [CmdletBinding(DefaultParameterSetName = "List")]
    Param(
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = "Get")]
        [Alias('Name', 'Policy', 'PolicySchema')]
        [String[]]
        $SchemaName,
        [Parameter(Mandatory = $false, ParameterSetName = "List")]
        [String]
        $Filter,
        [Parameter(Mandatory = $false, ParameterSetName = "List")]
        [ValidateRange(1, 1000)]
        [Alias('MaxResults')]
        [Int]
        $PageSize = 100,
        [Parameter(Mandatory = $false, ParameterSetName = "List")]
        [Alias('First')]
        [Int]
        $Limit = 0
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/chrome.management.policy.readonly'
            ServiceType = 'Google.Apis.ChromePolicy.v1.ChromePolicyService'
        }
        $service = New-GoogleService @serviceParams
        $customerId = if ($Script:PSGSuite.CustomerID) {
            $Script:PSGSuite.CustomerID
        }
        else {
            "my_customer"
        }
        $parentPath = "customers/$customerId"
    }
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Get {
                    foreach ($schema in $SchemaName) {
                        try {
                            Write-Verbose "Getting Chrome Policy Schema '$schema'"
                            # Handle both full paths and schema names
                            $schemaPath = if ($schema.StartsWith('customers/')) {
                                $schema
                            } else {
                                "$parentPath/policySchemas/$schema"
                            }
                            $request = $service.Customers.PolicySchemas.Get($schemaPath)
                            $request.Execute()
                        }
                        catch {
                            if ($ErrorActionPreference -eq 'Stop') {
                                $PSCmdlet.ThrowTerminatingError($_)
                            }
                            else {
                                Write-Error $_
                            }
                        }
                    }
                }
                List {
                    $request = $service.Customers.PolicySchemas.List($parentPath)
                    if ($Limit -gt 0 -and $PageSize -gt $Limit) {
                        Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with first page" -f $PageSize, $Limit)
                        $PageSize = $Limit
                    }
                    $request.PageSize = $PageSize
                    
                    if ($PSBoundParameters.ContainsKey('Filter')) {
                        Write-Verbose "Getting Chrome Policy Schemas with filter '$Filter'"
                        $request.Filter = $Filter
                    }
                    else {
                        Write-Verbose "Getting all Chrome Policy Schemas"
                    }

                    [int]$i = 1
                    $overLimit = $false
                    do {
                        $result = $request.Execute()
                        if ($result.PolicySchemas) {
                            $result.PolicySchemas
                        }
                        if ($result.NextPageToken) {
                            $request.PageToken = $result.NextPageToken
                        }
                        [int]$retrieved = ($i + $result.PolicySchemas.Count) - 1
                        Write-Verbose "Retrieved $retrieved Chrome Policy Schemas..."
                        if ($Limit -gt 0 -and $retrieved -eq $Limit) {
                            Write-Verbose "Limit reached: $Limit"
                            $overLimit = $true
                        }
                        elseif ($Limit -gt 0 -and ($retrieved + $PageSize) -gt $Limit) {
                            $newPS = $Limit - $retrieved
                            Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with next page" -f $PageSize, $newPS)
                            $request.PageSize = $newPS
                        }
                        [int]$i = $i + $result.PolicySchemas.Count
                    }
                    until ($overLimit -or !$result.NextPageToken)
                }
            }
        }
        catch {
            if ($ErrorActionPreference -eq 'Stop') {
                $PSCmdlet.ThrowTerminatingError($_)
            }
            else {
                Write-Error $_
            }
        }
    }
}