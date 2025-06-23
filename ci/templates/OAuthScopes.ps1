Param(
    [parameter(mandatory=$true)]$SourceDirectory
)


<#
    This template searches all public/private functions for the Google API services and OAuth Scopes that are used.

    It is assumed that each PSGSuite function has a 1:1 mapping to a .ps1 file, and the .ps1 file has the same name as the function.

    Each private/public function is checked for API services and OAuth scopes by:
    1. The function file is searched for any API service strings.
    2. If an API service string is found, all OAuth scopes are retrieved from the service object.
    3. The function file is searched for all OAuth scopes from the API service and any matches are recorded.
    4. The function file is then searched for any references to dependent PSGSuite functions.
    4. If a reference to another PSGSuite function is found, that functionm file is also checked for scopes if not already checked.
    5. If any API services or OAuth scopes were found for the referenced function, they are copied to the current function.

    The items found for all public functions are used to generate the PowerShell code that defines the following items:
    - $script:_PSGSuiteOAuthScopes - This is an array that contains all items that were found.
    - class [PSGSuiteValidServiceValues] - This is a parameter validation class that contains all Google API services that were found.
    - class [PSGSuiteValidFunctionValues] - This is a parameter validation class that contains all of the public PSGSuite function names.
    - class [PSGSuiteValidOAuthScopeValues] - This is a parameter validation class that contains all of the OAuth scopes that were found.

    The generated PowerShell code is output as a string to the pipeline so that it can be injected into the compiled module.
#>


Write-BuildLog "[OAuthScopes.ps1] Searching all PSGSuite functions for OAuth scopes."
Write-BuildLog "[OAuthScopes.ps1] Results are shown in format 'Unique (Found/Inherited)'"

# This should contain files that are not to be resolved for their scopes.
# Values are to be the file name exlcuding the '.ps1' extension. This should also be the function name
# as it is assumed that each file contains exactly one function.
$Script:ExcludeFunctions = @(
    'Get-GSShortUrlListPrivate'
)

Function Resolve-FunctionScopes {
    Param(
        [Parameter(Mandatory=$True)]
        [String]$FunctionName,
        [Parameter(Mandatory=$False)]
        [string[]]$NestedCalls = @()
    )

    # Check if function already resolved
    If ($Script:FunctionScopes.ContainsKey($FunctionName)){
        Return
    }

    $NestedCalls += $FunctionName
    $FunctionPath = $Script:FunctionPaths[$FunctionName]
    $DirectorySeperator = [Regex]::Escape([System.IO.Path]::DirectorySeparatorChar)

    $FriendlyPath = $FunctionPath -replace "^(.+$DirectorySeperator)(?<friendlyPath>(Private|Public)($DirectorySeperator[A-Za-z0-9- ]+)+?\.ps1)$",'${friendlyPath}'
    Write-BuildLog "[OAuthScopes.ps1] [$($NestedCalls.Count)] [$FunctionName] Resolving OAuth scopes in function '$FriendlyPath'"
    
    $Script:FunctionScopes[$FunctionName] = @{}

    $FunctionContent = [System.IO.File]::ReadAllText($FunctionPath)
    # Remove the comments, they may contain false positives
    $FunctionContent = $FunctionContent -replace "(?s)<#.+#>", ""
    $FunctionContent = $FunctionContent -replace "(?m)#.+$", ""

    # Find any Google API service strings in the file
    $MatchedServicesCount = 0
    $MatchedScopesCount = 0
    $Results = $FunctionContent | Select-String -Pattern "['`"](?<service>Google\.Apis(\.[a-zA-Z0-9_]+){3,4}Service)['`"]" -AllMatches
    If ($Results){
        $MatchedServiceStrings = @()
        ForEach ($Match in $Results.matches){
            $MatchedServiceStrings += $Match.Groups['service'].value
        }
        ForEach ($ServiceString in ($MatchedServiceStrings | Select-Object -Unique)){
            
            $MatchedServicesCount++
            
            If (-not $Script:FunctionScopes[$FunctionName].ContainsKey($ServiceString)){
                $Script:FunctionScopes[$FunctionName][$ServiceString] = [System.Collections.Generic.HashSet[String]]::new()
            }
            
            # Search the file for scope strings that belong to the service.
            # https://github.com/googleapis/google-api-dotnet-client/issues/367
            $ServiceScopes = ([Type]"$ServiceString+ScopeConstants").DeclaredFields.GetRawConstantValue()
            ForEach ($ScopeString in $ServiceScopes){
                If ($FunctionContent -match $ScopeString){
                    $MatchedScopesCount++
                    $Script:FunctionScopes[$FunctionName][$ServiceString].add($ScopeString) | Out-Null
                }
            }

        }

    }

    # Find any referenced PSGSuite functions in the file and inherit their scopes.
    $CopiedServicesCount = 0
    $CopiedScopesCount = 0
    ForEach ($PSGSuiteFunctionName in $Script:FunctionPaths.keys){
        
        # Don't search excluded files
        If ($Script:ExcludeFunctions -contains $PSGSuiteFunctionName){
            Continue
        }

        # Don't recursively search the current function
        If ($PSGSuiteFunctionName -eq $FunctionName){
            Continue
        }

        # Find any references to the function, skip if none found
        If ($FunctionContent -notmatch "$([Regex]::Escape($PSGSuiteFunctionName))[\s]"){
            Continue
        }
        
        # Check for a recursive loop.
        If ($NestedCalls -contains $PSGSuiteFunctionName){
            Write-BuildLog "[OAuthScopes.ps1] [$($NestedCalls.Count)] [$FunctionName] Recursive reference for function '$PSGSuiteFunctionName' detected: $($NestedCalls -Join " --> ")" -warning
            Continue
        }

        # Resolve the function's scopes, if neccessary
        If (-not $Script:FunctionScopes.ContainsKey($PSGSuiteFunctionName)){
            Resolve-FunctionScopes -FunctionName $PSGSuiteFunctionName -NestedCalls $NestedCalls
        }

        # copy the scopes
        ForEach ($ServiceKey in $Script:FunctionScopes[$PSGSuiteFunctionName].Keys){
            $CopiedServicesCount++
            If (-not $Script:FunctionScopes[$FunctionName].containsKey($ServiceKey)){
                $Script:FunctionScopes[$FunctionName][$ServiceKey] = [System.Collections.Generic.HashSet[String]]::new()
            }
            ForEach ($ScopeString in $Script:FunctionScopes[$PSGSuiteFunctionName][$ServiceKey]){
                $Script:FunctionScopes[$FunctionName][$ServiceKey].add($ScopeString) | Out-Null
                $CopiedScopesCount++
            }
        }
    }

    $UniqueScopesCount = ($Script:FunctionScopes[$FunctionName].values.count | Measure-Object -Sum).Sum
    Write-BuildLog "[OAuthScopes.ps1] [$($NestedCalls.Count)] [$FunctionName] Results - Services: $($Script:FunctionScopes[$FunctionName].Count) ($MatchedServicesCount/$CopiedServicesCount); Scopes: $UniqueScopesCount ($MatchedScopesCount/$CopiedScopesCount)"

}

$Script:FunctionScopes = @{}
$Script:FunctionPaths = @{}

# get all function files
foreach ($Scope in @('Private', 'Public')) {
    $functionsDirectory = Join-Path (Join-Path $SourceDirectory 'PSGSuite') $Scope
    Get-ChildItem -Path $FunctionsDirectory -Filter '*.ps1' -Recurse -File | Where-Object {$Script:ExcludeFunctions -notcontains $_.BaseName} | ForEach-Object {
        $Script:FunctionPaths[$_.BaseName] = $_.FullName
    }
}

# Resolve scopes in each file
foreach ($FunctionName in $FunctionPaths.Keys) {
    Resolve-FunctionScopes -FunctionName $FunctionName
}

# Filter for public functions only and generate the output hashtables
$PublicFunctionsDirectory = [Regex]::Escape((Join-Path (Join-Path $SourceDirectory 'PSGSuite') 'Public'))
$OutputScopes = @()
ForEach ($FunctionName in $Script:FunctionScopes.keys){
    If ($Script:FunctionPaths[$FunctionName] -match $PublicFunctionsDirectory){
        ForEach ($ServiceKey in $Script:FunctionScopes[$FunctionName].keys){
            ForEach ($ScopeString in $Script:FunctionScopes[$FunctionName][$ServiceKey].GetEnumerator()){
                $OutputScopes += [PSCustomObject]@{
                    'Function' = $FunctionName
                    'Service' = $ServiceKey
                    'Scope' = $ScopeString
                }
            }
        }
        # If no items were found, create an empty record.
        If ($Script:FunctionScopes[$FunctionName].Count -eq 0){
            $OutputScopes += [PSCustomObject]@{
                'Function' = $FunctionName
                'Service' = $null
                'Scope' = $null
            }
        }
    }
}

# Generate datasets that will be used to validate function parameters
$ValidServices = $OutputScopes | Select-Object -ExpandProperty 'Service' -Unique
$ValidFunctions = $OutputScopes | Select-Object -ExpandProperty 'Function' -Unique
$ValidScopes = $OutputScopes | Select-Object -ExpandProperty 'Scope' -Unique

# Return the output
$HashOutput = @{}


# \Module\OAuthScopes.ps1
$Code = @"
# Scope data that is used by the Get-PSGSuiteOAuthScope function.
`$script:_PSGSuiteOAuthScopes = @'
$($OutputScopes | ConvertTo-Json)
'@ | ConvertFrom-Json
"@
$HashOutput['\Module\OAuthScopes.ps1'] = $Code


# \Class\PSGSuiteValidServiceValues.ps1
$Code = @"
# Class that provides parameter validation for the Google API services that are used by PSGSuite.
class PSGSuiteValidServiceValues : System.Management.Automation.IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        `$Values = @(
            '$($ValidServices -join "',`n            '")'
        )
        return `$Values
    }
}
"@
$HashOutput['\Class\PSGSuiteValidServiceValues.ps1'] = $Code


# \Class\PSGSuiteValidFunctionValues.ps1
$Code =  @"
# Class that provides parameter validation for the names of the public PSGSuite functions.
class PSGSuiteValidFunctionValues : System.Management.Automation.IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        `$Values = @(
            '$($ValidFunctions -join "',`n            '")'
        )
        return `$Values
    }
}
"@
$HashOutput['\Class\PSGSuiteValidFunctionValues.ps1'] = $Code


# \Class\PSGSuiteValidOAuthScopeValues
$Code = @"
# Class that provides parameter validation for the list of OAuth scopes that are used by all PSGSuite functions.
class PSGSuiteValidOAuthScopeValues : System.Management.Automation.IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        `$Values = @(
            '$($ValidScopes -join "',`n            '")'
        )
        return `$Values
    }
}
"@
$HashOutput['\Class\PSGSuiteValidOAuthScopeValues.ps1'] = $Code


$HashOutput
