function Remove-GSPolicyGroup {
    <#
    .SYNOPSIS
    Rem            $description = if ($schemasToProcess.Count -eq 1) {
                "Removing Chrome Policy '$($schemasToProcess[0])' from Group '$GroupId'"
            } else {
                "Removing Chrome Policies (Count: $($schemasToProcess.Count)) from Group '$GroupId'"
            }
            
            if ($PSCmdlet.ShouldProcess($description)) {ome policies from groups

    .DESCRIPTION
    Deletes multiple Chrome policy values that are applied to a specific group.

    .PARAMETER GroupId
    The group ID to remove policies from.

    .PARAMETER PolicySchemas
    Array of policy schema names to remove from the group.

    .PARAMETER PolicySchema
    Single policy schema name to remove from the group.

    .EXAMPLE
    Remove-GSPolicyGroup -GroupId "04gd9a1x2bcdefg" -PolicySchema "chrome.users.URLAllowlist"

    Removes the URL allowlist policy from the specified group

    .EXAMPLE
    $schemas = @("chrome.users.URLAllowlist", "chrome.users.apps")
    Remove-GSPolicyGroup -GroupId "04gd9a1x2bcdefg" -PolicySchemas $schemas

    Removes multiple policies from the group using the PolicySchemas parameter
    #>
    [OutputType('Google.Apis.ChromePolicy.v1.Data.GoogleChromePolicyV1BatchDeleteGroupPoliciesResponse')]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High", DefaultParameterSetName = "Single")]
    Param(
        [Parameter(Mandatory = $true, Position = 0)]
        [String]
        $GroupId,
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
            # Determine which schemas to process
            $schemasToProcess = switch ($PSCmdlet.ParameterSetName) {
                "Single" { @($PolicySchema) }
                "Multiple" { $PolicySchemas }
            }
            
            $target = "Group: $GroupId"
            $action = if ($schemasToProcess.Count -eq 1) {
                "Remove Chrome Policy: $($schemasToProcess[0])"
            } else {
                "Remove Chrome Policies (Count: $($schemasToProcess.Count))"
            }
            
            if ($PSCmdlet.ShouldProcess($target, $action)) {
                Write-Verbose "Removing Chrome policies from group '$GroupId'"
            
            # Create the request body
            $body = New-Object 'Google.Apis.ChromePolicy.v1.Data.GoogleChromePolicyV1BatchDeleteGroupPoliciesRequest'
            $requests = New-Object 'System.Collections.Generic.List[Google.Apis.ChromePolicy.v1.Data.GoogleChromePolicyV1DeleteGroupPolicyRequest]'
            
            # Determine which schemas to process
            $schemasToProcess = switch ($PSCmdlet.ParameterSetName) {
                "Single" { @($PolicySchema) }
                "Multiple" { $PolicySchemas }
            }
            
            foreach ($schema in $schemasToProcess) {
                Write-Verbose "Creating delete request for schema '$schema'"
                $deleteRequest = New-Object 'Google.Apis.ChromePolicy.v1.Data.GoogleChromePolicyV1DeleteGroupPolicyRequest'
                
                # Set policy target key
                $policyTargetKey = New-Object 'Google.Apis.ChromePolicy.v1.Data.GoogleChromePolicyV1PolicyTargetKey'
                $policyTargetKey.TargetResource = "groups/$GroupId"
                $deleteRequest.PolicyTargetKey = $policyTargetKey
                
                # Set policy schema
                $deleteRequest.PolicySchema = $schema
                
                $requests.Add($deleteRequest)
            }
            
            $body.Requests = $requests
            
            $request = $service.Customers.Policies.Groups.BatchDelete($body, $customerPath)
            $result = $request.Execute()
            
            if ($result) {
                Write-Verbose "Successfully removed policies from group '$GroupId'"
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