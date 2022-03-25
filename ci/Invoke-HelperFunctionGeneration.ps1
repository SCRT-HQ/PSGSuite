function Invoke-HelperFunctionGeneration {
    [CmdletBinding()]
    Param (
        [parameter(Mandatory = $true,Position = 0)]
        [String]
        $BaseType = 'Google.Apis.Sheets.v4.Data.BandedRange'
    )
    $TargetApi = $BaseType.Split('.')[2].TrimEnd('s')
    $OutputPath = [System.IO.Path]::Combine($PSScriptRoot,'..','PSGSuite','Public','Helpers','CIGenerated')
    $req = New-Object $BaseType
    $paramBlock = @()
    $paramHelpBlock = @()
    $listParamBlock = @()
    $exampleParamString = ""
    $requestType = $BaseType.Split('.')[-1]
    $fnName = "Add-GS" + $TargetApi + $requestType
    $outPath = Join-Path $OutputPath "$($fnName).ps1"
    if (Test-Path $outPath) {Write-Verbose "Helper function $outPath already exists";return}

    $req | Get-Member -MemberType Property | Where-Object {$_.Name -ne 'ETag'} | ForEach-Object {
        $paramName = $_.Name
        $fullType = $_.Definition.Split(' ',2)[0]
        if ($fullType -match '\[.*\]') {
            $typeSplit = ($fullType | Select-String -Pattern '([\w|\.]+)\[(.*)\]' -AllMatches).Matches.Groups[1..2].Value
            $isList = $typeSplit[0] -match 'IList'
            $fullType = $typeSplit[1]
        }
        else {
            $isList = $fullType -match 'IList'
            $fullType = $fullType
        }
        if ($fullType -eq 'bool') {
            $fullType = 'switch'
        }
        $paramType = if ($isList) {
            "$fullType[]"
        }
        else {
            $fullType
        }
        $paramName = $_.Name
        $paramBlock += "        [parameter()]`n        [$paramType]`n        `$$paramName,"
        if ($paramType -match '^Google\.') {
            $helperFunctionName = "Add-GS" + $TargetApi + $(if ($fullType -match '\.'){$fullType.Split('.')[-1]}else{$fullType})
            $paramHelpBlock += ".PARAMETER $paramName`n    Accepts the following type: [$paramType].`n`n    To create this type, use the function $helperFunctionName or instantiate the type directly via New-Object '$fullType'.`n"
        }
        else {
            $paramHelpBlock += ".PARAMETER $paramName`n    Accepts the following type: [$paramType].`n"
        }
        $exampleParamString += " -$paramName `$$($paramName.Substring(0,1).ToLower())$($paramName.Substring(1))"
        if ($isList) {
            $listParamBlock += @"
                            $paramName {
                                `$list = New-Object 'System.Collections.Generic.List[$fullType]'
                                foreach (`$item in `$$paramName) {
                                    `$list.Add(`$item)
                                }
                                `$obj.$paramName = `$list
                            }
"@
        }
    }

    $fnValue = @"
function $fnName {
    <#
    .SYNOPSIS
    Creates a $BaseType object.

    .DESCRIPTION
    Creates a $BaseType object.

    $($paramHelpBlock -join "`n    ")
    .EXAMPLE
    $fnName$exampleParamString
    #>
    [OutputType('$BaseType')]
    [CmdletBinding()]
    Param(
$($paramBlock -join "`n")
        [parameter(Mandatory = `$false,ValueFromPipeline = `$true,ParameterSetName = "InputObject")]
        [$BaseType[]]
        `$InputObject
    )
    Process {
        try {
            switch (`$PSCmdlet.ParameterSetName) {
                Fields {
                    `$obj = New-Object '$BaseType'
                    foreach (`$prop in `$PSBoundParameters.Keys | Where-Object {`$obj.PSObject.Properties.Name -contains `$_}) {
                        switch (`$prop) {$(if($listParamBlock.Count){"`n" + ($listParamBlock -join "`n")})
                            default {
                                `$obj.`$prop = `$PSBoundParameters[`$prop]
                            }
                        }
                    }
                    `$obj
                }
                InputObject {
                    foreach (`$iObj in `$InputObject) {
                        `$obj = New-Object '$BaseType'
                        foreach (`$prop in `$iObj.PSObject.Properties.Name | Where-Object {`$obj.PSObject.Properties.Name -contains `$_ -and `$_ -ne 'ETag'}) {
                            `$obj.`$prop = `$iObj.`$prop
                        }
                        `$obj
                    }
                }
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
    Write-Verbose "Generating Helper function: $outPath"
    Set-Content -Path $outPath -Value $fnValue -Force

    # This duplicates much of the code used above to generate the parameter list
    # Here we are using that same information to generate Help functions for any data types needed by this function
    # It can't be done within the loop before a file is generated, because it uses recursion, and some objects have infinite recursion
    # As an example, a Slide Page Element has a Group object, a Group object is an array of Page Elements, which each contain a Group object...
    # Here use recursion after the file has already written.
    # There is a check at the top that will check if function we're trying to generate already exists and exits if not.
    # This prevents infinte recursion, and allows all functions to be succesfully generated
    $req | Get-Member -MemberType Property | Where-Object {$_.Name -ne 'ETag'} | ForEach-Object {
        $fullType = $_.Definition.Split(' ',2)[0]
        if ($fullType -match '\[.*\]') {
            $typeSplit = ($fullType | Select-String -Pattern '([\w|\.]+)\[(.*)\]' -AllMatches).Matches.Groups[1..2].Value
            $isList = $typeSplit[0] -match 'IList'
            $fullType = $typeSplit[1]
        }
        else {
            $isList = $fullType -match 'IList'
            $fullType = $fullType
        }
        if ($fullType -eq 'bool') {
            $fullType = 'switch'
        }
        $paramType = if ($isList) {
            "$fullType[]"
        }
        else {
            $fullType
        }
        if ($paramType -match '^Google\.') {
            Invoke-HelperFunctionGeneration -BaseType $fullType
        }
    }
}
