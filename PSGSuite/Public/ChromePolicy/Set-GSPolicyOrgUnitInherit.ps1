function Set-GSPolicyOrgUnitInherit {
    <#
    .SYNOPSIS
    Sets Chrome policies to inherit from parent organizational unit

    .DESCRIPTION
    Modifies multiple Chrome policy values that are applied to a specific organizational unit so that they inherit the value from a parent (if applicable).

    .PARAMETER OrgUnitId
    The organizational unit ID to set policy inheritance for.

    .PARAMETER PolicySchemas
    Array of policy schema names to set to inherit from parent.

    .PARAMETER PolicySchema
    Single policy schema name to set to inherit from parent.

    .EXAMPLE
    Set-GSPolicyOrgUnitInherit -OrgUnitId "03ph8a2z1qtgfqh" -PolicySchema "chrome.users.URLAllowlist"

    Sets the URL allowlist policy to inherit from parent for the specified organizational unit

    .EXAMPLE
    $schemas = @("chrome.users.URLAllowlist", "chrome.users.apps")
    Set-GSPolicyOrgUnitInherit -OrgUnitId "03ph8a2z1qtgfqh" -PolicySchemas $schemas

    Sets multiple policies to inherit from parent using the PolicySchemas parameter
    #>
    [OutputType('Google.Apis.ChromePolicy.v1.Data.GoogleChromePolicyV1BatchInheritOrgUnitPoliciesResponse')]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium", DefaultParameterSetName = "Single")]
    Param(
        [Parameter(Mandatory = $true, Position = 0)]
        [String]
        $OrgUnitId,
        [Parameter(Mandatory = $true, ParameterSetName = "Multiple")]
        [String[]]
        $PolicySchemas,
        [Parameter(Mandatory = $true, ParameterSetName = "Single")]
        [String]
        $PolicySchema
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/chrome.management.policy'
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
            $schemasToProcess = switch ($PSCmdlet.ParameterSetName) {
                "Single" { @($PolicySchema) }
                "Multiple" { $PolicySchemas }
            }
            
            $description = if ($schemasToProcess.Count -eq 1) {
                "Setting Chrome Policy '$($schemasToProcess[0])' to inherit from parent for Organizational Unit '$OrgUnitId'"
            } else {
                "Setting Chrome Policies (Count: $($schemasToProcess.Count)) to inherit from parent for Organizational Unit '$OrgUnitId'"
            }
            
            if ($PSCmdlet.ShouldProcess($description)) {
                Write-Verbose "Setting Chrome policies to inherit from parent for organizational unit '$OrgUnitId'"
            
            # Create the request body
            $body = New-Object 'Google.Apis.ChromePolicy.v1.Data.GoogleChromePolicyV1BatchInheritOrgUnitPoliciesRequest'
            $requests = New-Object 'System.Collections.Generic.List[Google.Apis.ChromePolicy.v1.Data.GoogleChromePolicyV1InheritOrgUnitPolicyRequest]'
            
            # Determine which schemas to process
            $schemasToProcess = switch ($PSCmdlet.ParameterSetName) {
                "Single" { @($PolicySchema) }
                "Multiple" { $PolicySchemas }
            }
            
            foreach ($schema in $schemasToProcess) {
                Write-Verbose "Creating inheritance request for schema '$schema'"
                $inheritRequest = New-Object 'Google.Apis.ChromePolicy.v1.Data.GoogleChromePolicyV1InheritOrgUnitPolicyRequest'
                
                # Set policy target key
                $policyTargetKey = New-Object 'Google.Apis.ChromePolicy.v1.Data.GoogleChromePolicyV1PolicyTargetKey'
                $policyTargetKey.TargetResource = "orgunits/$OrgUnitId"
                $inheritRequest.PolicyTargetKey = $policyTargetKey
                
                # Set policy schema
                $inheritRequest.PolicySchema = $schema
                
                $requests.Add($inheritRequest)
            }
            
            $body.Requests = $requests
            
            $request = $service.Customers.Policies.Orgunits.BatchInherit($body, $customerPath)
            $result = $request.Execute()
            
            if ($result) {
                Write-Verbose "Successfully set policies to inherit from parent for organizational unit '$OrgUnitId'"
                $result
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