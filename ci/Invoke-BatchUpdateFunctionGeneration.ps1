function Invoke-BatchUpdateFunctionGeneration {
    [CmdletBinding()]
    Param (
        [parameter(Mandatory = $true,Position = 0)]
        [String]
        $BaseType
    )
    $OutputPath = [System.IO.Path]::Combine($PSScriptRoot,'..','PSGSuite','Public','Helpers','CIGenerated')
    $TargetApi = $BaseType.Split('.')[2].TrimEnd('s')
    $req = New-Object $BaseType
    ($req | Get-Member -MemberType Property | Where-Object {$_.Name -ne 'ETag'}).Definition | ForEach-Object {
        $fullType = $_.Split(' ',2)[0]
        $requestType = $fullType.Split('.')[-1]
        $fnName = "Add-GS" + $TargetApi + $requestType
        $subType = New-Object $fullType
        $paramBlock = @()
        $paramHelpBlock = @()
        $listOrDictParamBlock = @()
        $exampleParamString = ""
        $subType | Get-Member -MemberType Property | Where-Object {$_.Name -ne 'ETag'} | ForEach-Object {
            $paramName = $_.Name
            $paramType = $_.Definition.Split(' ',2)[0]
            if ($paramType -match '\[.*\]') {
                $typeSplit = ($paramType | Select-String -Pattern '([\w|\.]+)\[(.*)\]' -AllMatches).Matches.Groups[1..2].Value
                if ($typeSplit[0] -match 'IList') {
                    $isList = $true
                    $isDict = $false
                    $dictKey = $null
                    $paramType = $typeSplit[1]
                }
                elseif ($typeSplit[0] -match 'IDictionary') {
                    $isDict = $true
                    $isList = $false
                    $dictKey, $paramType = $typeSplit[1].Split(',')
                }
                else {
                    # So far the only types that triger this are Nullable values
                    # System.Nullable[int]
                    # System.Nullable[float]
                    # System.Nullable[bool]
                    # System.Nullable[double]
                    # System.Nullable[long]
                    $isList = $false
                    $isDict = $false
                    $dictKey = $null
                    $paramType = $paramType
                }
            }
            else {
                $isList = $false
                $isDict = $false
                $dictKey = $null
                $paramType = $paramType
            }
            if ($paramType -eq 'bool') {
                $paramType = 'switch'
            }
            $paramBlockType = if ($isList) {
                "$paramType[]"
            }
            elseif ($isDict) {
                'System.Collections.Hashtable'
            }
            else {
                $paramType
            }
            $paramBlock += "        [parameter()]`n        [$paramBlockType]`n        `$$paramName,"
            if ($paramType -match '^Google\.') {
                $helperFunctionName = "Add-GS" + $TargetApi + $(if ($paramType -match '\.'){$paramType.Split('.')[-1]}else{$paramType})
                if ($isList) {
                    $paramHelpBlock += ".PARAMETER $paramName`n    Accepts the following type: [$paramBlockType].`n`n    To create this type, use the function $helperFunctionName or instantiate the type directly via New-Object '$paramType'.`n"
                }
                elseif ($isDict) {
                    $dictHelpBlock = ".PARAMETER $paramName`n    Accepts the following type: [$paramBlockType]."
                    $dictHelpBlock += "`n    The key(s) of the Hashtable should be a [$dictKey] and the value(s) should be a [$paramType]"
                    $dictHelpBlock += "`n`n    To create an object of type [$paramType], use the function $helperFunctionName or instantiate the type directly via New-Object '$paramType'.`n"
                    $paramHelpBlock += $dictHelpBlock
                }
                else {
                    $paramHelpBlock += ".PARAMETER $paramName`n    Accepts the following type: [$paramBlockType].`n`n    To create this type, use the function $helperFunctionName or instantiate the type directly via New-Object '$paramBlockType'.`n"
                }
                Invoke-HelperFunctionGeneration -BaseType $paramType
            }
            else {
                if ($isList) {
                    $paramHelpBlock += ".PARAMETER $paramName`n    Accepts the following type: [$paramBlockType].`n"
                }
                elseif ($isDict) {
                    $dictHelpBlock = ".PARAMETER $paramName`n    Accepts the following type: [$paramBlockType]."
                    $dictHelpBlock += "`n    The key(s) of the Hashtable should be a [$dictKey] and the value(s) should be a [$paramType]`n"
                    $paramHelpBlock += $dictHelpBlock
                }
                else {
                    $paramHelpBlock += ".PARAMETER $paramName`n    Accepts the following type: [$paramBlockType].`n"
                }
            }
            $exampleParamString += " -$paramName `$$($paramName.Substring(0,1).ToLower())$($paramName.Substring(1))"
            if ($isList) {
                $listOrDictParamBlock += @"
                $paramName {
                    `$list = New-Object 'System.Collections.Generic.List[$paramType]'
                    foreach (`$item in `$$paramName) {
                        `$list.Add(`$item)
                    }
                    `$newRequest.$paramName = `$list
                }
"@
            }
            if ($isDict) {
                $listOrDictParamBlock += @"
                $paramName {
                    `$dict = New-Object 'System.Collections.Generic.Dictionary[[$dictKey],[$paramType]]'
                    foreach (`$item in `$$paramName.GetEnumerator()) {
                        `$dict.Add(`$item.Key,`$item.Value)
                    }
                    `$newRequest.$paramName = `$dict
                }
"@
            }
        }
        $paramHelpBlock += ".PARAMETER Requests`n    Enables pipeline input of other requests of the same type.`n"
        $fnValue = @"
function $fnName {
    <#
    .SYNOPSIS
    Creates a $requestType to pass to Submit-GS$($TargetApi)BatchUpdate.

    .DESCRIPTION
    Creates a $requestType to pass to Submit-GS$($TargetApi)BatchUpdate.

    $($paramHelpBlock -join "`n    ")
    .EXAMPLE
    $fnName$exampleParamString
    #>
    [OutputType('$BaseType')]
    [CmdletBinding()]
    Param(
$($paramBlock -join "`n")
        [parameter(ValueFromPipeline = `$true)]
        [$BaseType[]]
        `$Requests
    )
    Begin {
        Write-Verbose "Adding $requestType to the pipeline"
    }
    Process {
        if (`$Requests) {
            `$Requests
        }
    }
    End {
        `$newRequest = New-Object '$fullType'
        foreach (`$prop in `$PSBoundParameters.Keys | Where-Object {`$newRequest.PSObject.Properties.Name -contains `$_}) {
            switch (`$prop) {$(if($listOrDictParamBlock.Count){"`n" + ($listOrDictParamBlock -join "`n")})
                default {
                    `$newRequest.`$prop = `$PSBoundParameters[`$prop]
                }
            }
        }
        try {
            New-Object '$BaseType' -Property @{
                $($requestType -replace 'Request$','') = `$newRequest
            }
        }
        catch {
            if (`$ErrorActionPreference -eq 'Stop') {
                `$PSCmdlet.ThrowTerminatingError(`$_)
            }
            else {
                Write-Error `$_
            }
        }
    }
}
"@
        $outPath = Join-Path $OutputPath "$($fnName).ps1"
        Write-Verbose "Generating BatchUpdate function: $outPath"
        Set-Content -Path $outPath -Value $fnValue -Force
    }
}
