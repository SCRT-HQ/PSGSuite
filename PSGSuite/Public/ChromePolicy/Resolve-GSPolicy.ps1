function Resolve-GSPolicy {
    <#
    .SYNOPSIS
    Gets resolved policy values for Chrome policies

    .DESCRIPTION
    Gets the resolved policy values for a list of policies that match a search query.

    .PARAMETER PolicySchemaFilter
    Required. Filter for policy schemas. Use the format "chrome.users.apps" or specific schema names.

    .PARAMETER OrgUnitId
    The organizational unit ID to get policies for. Cannot be used with GroupId.

    .PARAMETER GroupId  
    The group ID to get policies for. Cannot be used with OrgUnitId.

    .PARAMETER PageSize
    Maximum number of policy values to return in a single request. Default is 100.

    .PARAMETER Limit
    Maximum number of policy values to return. Set to 0 to return all results.

    .EXAMPLE
    Resolve-GSPolicy -PolicySchemaFilter "chrome.users.apps" -OrgUnitId "03ph8a2z1qtgfqh"

    Gets resolved policy values for user app policies in a specific organizational unit

    .EXAMPLE
    Resolve-GSPolicy -PolicySchemaFilter "chrome.devices.managedguest" -GroupId "04gd9a1x2bcdefg"

    Gets resolved policy values for managed guest policies in a specific group
    #>
    [OutputType('Google.Apis.ChromePolicy.v1.Data.GoogleChromePolicyV1ResolveResponse')]
    [CmdletBinding(DefaultParameterSetName = "OrgUnit")]
    Param(
        [Parameter(Mandatory = $true, Position = 0)]
        [String]
        $PolicySchemaFilter,
        [Parameter(Mandatory = $true, ParameterSetName = "OrgUnit")]
        [String]
        $OrgUnitId,
        [Parameter(Mandatory = $true, ParameterSetName = "Group")]
        [String]
        $GroupId,
        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 1000)]
        [Alias('MaxResults')]
        [Int]
        $PageSize = 100,
        [Parameter(Mandatory = $false)]
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
        $customerPath = "customers/$customerId"
    }
    Process {
        try {
            Write-Verbose "Resolving Chrome Policy values for filter '$PolicySchemaFilter'"
            
            # Create the request body
            $body = New-Object 'Google.Apis.ChromePolicy.v1.Data.GoogleChromePolicyV1ResolveRequest'
            $body.PolicySchemaFilter = $PolicySchemaFilter
            
            # Set the policy target key based on the parameter set
            $policyTargetKey = New-Object 'Google.Apis.ChromePolicy.v1.Data.GoogleChromePolicyV1PolicyTargetKey'
            switch ($PSCmdlet.ParameterSetName) {
                "OrgUnit" {
                    $policyTargetKey.TargetResource = "orgunits/$OrgUnitId"
                    Write-Verbose "Targeting organizational unit: $OrgUnitId"
                }
                "Group" {
                    $policyTargetKey.TargetResource = "groups/$GroupId"  
                    Write-Verbose "Targeting group: $GroupId"
                }
            }
            $body.PolicyTargetKey = $policyTargetKey

            if ($Limit -gt 0 -and $PageSize -gt $Limit) {
                Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with first page" -f $PageSize, $Limit)
                $PageSize = $Limit
            }
            $body.PageSize = $PageSize

            $request = $service.Customers.Policies.Resolve($body, $customerPath)
            
            [int]$i = 1
            $overLimit = $false
            do {
                $result = $request.Execute()
                if ($result.PolicyValues) {
                    $result.PolicyValues
                }
                if ($result.NextPageToken) {
                    $body.PageToken = $result.NextPageToken
                    $request = $service.Customers.Policies.Resolve($body, $customerPath)
                }
                [int]$retrieved = ($i + $result.PolicyValues.Count) - 1
                Write-Verbose "Retrieved $retrieved policy values..."
                if ($Limit -gt 0 -and $retrieved -eq $Limit) {
                    Write-Verbose "Limit reached: $Limit"
                    $overLimit = $true
                }
                elseif ($Limit -gt 0 -and ($retrieved + $PageSize) -gt $Limit) {
                    $newPS = $Limit - $retrieved
                    Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with next page" -f $PageSize, $newPS)
                    $body.PageSize = $newPS
                    $request = $service.Customers.Policies.Resolve($body, $customerPath)
                }
                [int]$i = $i + $result.PolicyValues.Count
            }
            until ($overLimit -or !$result.NextPageToken)
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