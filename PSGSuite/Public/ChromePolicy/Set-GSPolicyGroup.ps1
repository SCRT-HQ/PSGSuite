function Set-GSPolicyGroup {
    <#
    .SYNOPSIS
    Modifies Chrome policies for groups

    .DESCRIPTION
    Modifies multiple Chrome policy values that are applied to a specific group.

    .PARAMETER GroupId
    The group ID to modify policies for.

    .PARAMETER PolicyModifications
    Array of policy modifications. Each modification should be a hashtable with PolicySchema, PolicyValue, and optionally UpdateMask properties.

    .PARAMETER PolicySchema
    The policy schema name (e.g., "chrome.users.apps").

    .PARAMETER PolicyValue
    The policy value to set. Can be a hashtable of policy settings.

    .PARAMETER UpdateMask
    The update mask specifying which fields to update. If not provided, all fields will be updated.

    .EXAMPLE
    $policyValue = @{
        "value" = @{
            "allowedUrls" = @("https://example.com", "https://google.com")
        }
    }
    Set-GSPolicyGroup -GroupId "04gd9a1x2bcdefg" -PolicySchema "chrome.users.URLAllowlist" -PolicyValue $policyValue

    Sets a URL allowlist policy for the specified group

    .EXAMPLE
    $modifications = @(
        @{
            PolicySchema = "chrome.users.apps"
            PolicyValue = @{
                "value" = @{
                    "installType" = "FORCE_INSTALLED"
                }
            }
        }
    )
    Set-GSPolicyGroup -GroupId "04gd9a1x2bcdefg" -PolicyModifications $modifications

    Sets multiple policies using the PolicyModifications parameter
    #>
    [OutputType('Google.Apis.ChromePolicy.v1.Data.GoogleChromePolicyV1BatchModifyGroupPoliciesResponse')]
    [CmdletBinding(DefaultParameterSetName = "Single")]
    Param(
        [Parameter(Mandatory = $true, Position = 0)]
        [String]
        $GroupId,
        [Parameter(Mandatory = $true, ParameterSetName = "Batch")]
        [Array]
        $PolicyModifications,
        [Parameter(Mandatory = $true, ParameterSetName = "Single")]
        [String]
        $PolicySchema,
        [Parameter(Mandatory = $true, ParameterSetName = "Single")]
        [Object]
        $PolicyValue,
        [Parameter(Mandatory = $false, ParameterSetName = "Single")]
        [String]
        $UpdateMask
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
            Write-Verbose "Modifying Chrome policies for group '$GroupId'"
            
            # Create the request body
            $body = New-Object 'Google.Apis.ChromePolicy.v1.Data.GoogleChromePolicyV1BatchModifyGroupPoliciesRequest'
            $requests = New-Object 'System.Collections.Generic.List[Google.Apis.ChromePolicy.v1.Data.GoogleChromePolicyV1ModifyGroupPolicyRequest]'
            
            switch ($PSCmdlet.ParameterSetName) {
                "Single" {
                    Write-Verbose "Creating single policy modification for schema '$PolicySchema'"
                    $modifyRequest = New-Object 'Google.Apis.ChromePolicy.v1.Data.GoogleChromePolicyV1ModifyGroupPolicyRequest'
                    
                    # Set policy target key
                    $policyTargetKey = New-Object 'Google.Apis.ChromePolicy.v1.Data.GoogleChromePolicyV1PolicyTargetKey'
                    $policyTargetKey.TargetResource = "groups/$GroupId"
                    $modifyRequest.PolicyTargetKey = $policyTargetKey
                    
                    # Set policy value
                    $policyValueObj = New-Object 'Google.Apis.ChromePolicy.v1.Data.GoogleChromePolicyV1PolicyValue'
                    $policyValueObj.PolicySchema = $PolicySchema
                    if ($PolicyValue -is [hashtable]) {
                        $policyValueObj.Value = ConvertTo-Json $PolicyValue -Depth 10
                    }
                    else {
                        $policyValueObj.Value = $PolicyValue
                    }
                    $modifyRequest.PolicyValue = $policyValueObj
                    
                    # Set update mask if provided
                    if ($UpdateMask) {
                        $modifyRequest.UpdateMask = $UpdateMask
                    }
                    
                    $requests.Add($modifyRequest)
                }
                "Batch" {
                    Write-Verbose "Creating batch policy modifications for $($PolicyModifications.Count) policies"
                    foreach ($modification in $PolicyModifications) {
                        $modifyRequest = New-Object 'Google.Apis.ChromePolicy.v1.Data.GoogleChromePolicyV1ModifyGroupPolicyRequest'
                        
                        # Set policy target key
                        $policyTargetKey = New-Object 'Google.Apis.ChromePolicy.v1.Data.GoogleChromePolicyV1PolicyTargetKey'
                        $policyTargetKey.TargetResource = "groups/$GroupId"
                        $modifyRequest.PolicyTargetKey = $policyTargetKey
                        
                        # Set policy value
                        $policyValueObj = New-Object 'Google.Apis.ChromePolicy.v1.Data.GoogleChromePolicyV1PolicyValue'
                        $policyValueObj.PolicySchema = $modification.PolicySchema
                        if ($modification.PolicyValue -is [hashtable]) {
                            $policyValueObj.Value = ConvertTo-Json $modification.PolicyValue -Depth 10
                        }
                        else {
                            $policyValueObj.Value = $modification.PolicyValue
                        }
                        $modifyRequest.PolicyValue = $policyValueObj
                        
                        # Set update mask if provided
                        if ($modification.UpdateMask) {
                            $modifyRequest.UpdateMask = $modification.UpdateMask
                        }
                        
                        $requests.Add($modifyRequest)
                    }
                }
            }
            
            $body.Requests = $requests
            
            $request = $service.Customers.Policies.Groups.BatchModify($body, $customerPath)
            $result = $request.Execute()
            
            if ($result) {
                Write-Verbose "Successfully modified policies for group '$GroupId'"
                $result
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