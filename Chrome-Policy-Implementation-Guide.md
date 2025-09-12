# Adding Chrome Policy Functions to PSGSuite

This document explains how to implement Chrome Policy API functions in PSGSuite and serves as a guide for adding new Google API services to the module.

## Overview

PSGSuite is a PowerShell module that wraps Google's .NET SDKs, enabling administrators to manage Google Workspace (formerly G Suite) services through PowerShell. The module uses Google's official .NET client libraries (NuGet packages) and provides PowerShell functions that follow consistent patterns.

## Architecture Understanding

### Core Components

1. **Google .NET SDKs**: PSGSuite loads Google API client libraries as .NET assemblies (DLLs)
2. **New-GoogleService**: Creates authenticated service objects for API calls
3. **Function Structure**: Consistent PowerShell function patterns across all APIs
4. **Configuration**: Centralized authentication and customer configuration

### How PSGSuite Integrates with .NET APIs

1. **Assembly Loading**: The `Import-GoogleSDK` private function loads Google API DLLs from the `lib` directory
2. **Service Creation**: `New-GoogleService` creates authenticated service objects with proper scopes
3. **API Calls**: Functions use the service objects to make API requests following Google's .NET SDK patterns

## Adding Chrome Policy API Support

### Step 1: Research the API

**Chrome Policy API Details:**
- **Service Endpoint**: `https://chromepolicy.googleapis.com`
- **NuGet Package**: `Google.Apis.ChromePolicy.v1` (current: v1.69.0.3776)
- **Service Type**: `Google.Apis.ChromePolicy.v1.ChromePolicyService`
- **Scopes**:
  - `https://www.googleapis.com/auth/chrome.management.policy` (read/write)
  - `https://www.googleapis.com/auth/chrome.management.policy.readonly` (read-only)

### Step 2: Update Dependencies

Add the Chrome Policy SDK to the NuGet dependencies:

```json
{
  "Name": "Google.Apis.ChromePolicy.v1.dll",
  "BaseName": "Google.Apis.ChromePolicy.v1",
  "Target": "Latest",
  "LatestVersion": "1.69.0.3776"
}
```

### Step 3: Create Directory Structure

Create the function directory following PSGSuite patterns:
```
PSGSuite/Public/Chrome Policy/
```

### Step 4: Implement Functions

#### Function Naming Convention
- Use PSGSuite prefix: `Get-GS`, `Set-GS`, `New-GS`, `Remove-GS`
- Use descriptive names: `Get-GSPolicySchema`, `Resolve-GSPolicy`

#### Standard Function Structure

```powershell
function Get-GSExample {
    <#
    .SYNOPSIS
    Brief description
    
    .DESCRIPTION
    Detailed description
    
    .PARAMETER ParamName
    Parameter description
    
    .EXAMPLE
    Example usage
    #>
    [OutputType('Google.Apis.ChromePolicy.v1.Data.ResponseType')]
    [CmdletBinding(DefaultParameterSetName = "List")]
    Param(
        # Parameters
    )
    Begin {
        # Service creation
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/chrome.management.policy.readonly'
            ServiceType = 'Google.Apis.ChromePolicy.v1.ChromePolicyService'
        }
        $service = New-GoogleService @serviceParams
        
        # Customer ID handling
        $customerId = if ($Script:PSGSuite.CustomerID) {
            $Script:PSGSuite.CustomerID
        }
        else {
            "my_customer"
        }
    }
    Process {
        # API logic with error handling
        try {
            # API calls
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
```

#### Key Patterns

1. **Authentication**: Always use `New-GoogleService` with appropriate scopes
2. **Customer ID**: Use `$Script:PSGSuite.CustomerID` or "my_customer"
3. **Error Handling**: Consistent try/catch with ErrorActionPreference handling
4. **Pagination**: Implement pagination for list operations
5. **Verbose Output**: Use `Write-Verbose` for operation feedback
6. **Output Types**: Specify `[OutputType()]` with Google API data types

### Step 5: Implemented Chrome Policy Functions

The following functions were created following PSGSuite patterns:

1. **`Get-GSPolicySchema`**: Lists or gets specific policy schemas
   - Supports filtering by namespace
   - Implements pagination
   - Two parameter sets: List and Get

2. **`Resolve-GSPolicy`**: Gets resolved policy values for org units or groups
   - Supports both organizational units and groups
   - Implements pagination for large result sets

3. **`Set-GSPolicyOrgUnit`**: Modifies policies for organizational units
   - Supports single policy or batch modifications
   - Handles JSON serialization for policy values

4. **`Set-GSPolicyGroup`**: Modifies policies for groups
   - Same pattern as org unit function
   - Supports batch operations

5. **`Set-GSPolicyOrgUnitInherit`**: Sets policies to inherit from parent
   - Supports single or multiple schema inheritance

6. **`Remove-GSPolicyGroup`**: Deletes policies from groups
   - Supports single or multiple policy deletion

### Step 6: Authentication and Scopes

Chrome Policy API requires specific OAuth scopes:
- **Read-only**: `https://www.googleapis.com/auth/chrome.management.policy.readonly`
- **Read-write**: `https://www.googleapis.com/auth/chrome.management.policy`

Ensure your Google Cloud project has:
1. Chrome Policy API enabled
2. Appropriate OAuth consent screen configuration
3. Service account or OAuth credentials configured

### Step 7: Testing and Usage

Basic usage examples:

```powershell
# List all policy schemas
Get-GSPolicySchema

# Get schemas for user apps
Get-GSPolicySchema -Filter "chrome.users.apps"

# Get resolved policies for an org unit
Resolve-GSPolicy -PolicySchemaFilter "chrome.users.URLAllowlist" -OrgUnitId "03ph8a2z1qtgfqh"

# Set a policy for an org unit
$policyValue = @{
    "value" = @{
        "allowedUrls" = @("https://example.com")
    }
}
Set-GSPolicyOrgUnit -OrgUnitId "03ph8a2z1qtgfqh" -PolicySchema "chrome.users.URLAllowlist" -PolicyValue $policyValue
```

## General Guidelines for Adding New APIs

### Research Phase
1. Check Google's API documentation
2. Verify .NET SDK availability on NuGet
3. Identify required scopes and authentication methods
4. Understand API endpoints and data structures

### Implementation Phase
1. Add NuGet package to dependencies
2. Create appropriate directory structure
3. Implement functions following PSGSuite patterns
4. Use consistent naming conventions
5. Implement proper error handling and pagination

### Best Practices
1. **Consistency**: Follow existing PSGSuite patterns
2. **Documentation**: Include comprehensive help text
3. **Error Handling**: Use consistent error handling patterns
4. **Scoping**: Use minimal required permissions
5. **Testing**: Test with real API calls when possible

### Common Patterns
- Use `$Script:PSGSuite.CustomerID` for customer identification
- Implement pagination for list operations
- Use `ConvertTo-Json` for complex object serialization
- Support both single and batch operations where applicable
- Use parameter sets to handle different operation modes

## Troubleshooting

### Common Issues
1. **Assembly Loading**: Ensure DLL is in the lib directory and loaded properly
2. **Authentication**: Verify scopes and credentials are properly configured
3. **API Limits**: Implement proper pagination and rate limiting
4. **Data Types**: Use correct Google API data types for parameters and returns

### Debug Steps
1. Check verbose output with `-Verbose`
2. Verify service object creation
3. Test API calls with minimal parameters
4. Check Google Cloud Console for API quotas and errors

## Conclusion

Adding Chrome Policy functions to PSGSuite follows the established patterns used throughout the module. The key is understanding how PSGSuite wraps Google's .NET SDKs and following consistent patterns for authentication, error handling, and API interaction.

This approach can be applied to any Google API that has a corresponding .NET SDK package available on NuGet.