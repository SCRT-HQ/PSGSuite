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

    $req | Get-Member -MemberType Property | Where-Object {$_.Name -ne 'ETag'} | ForEach-Object {
        $paramName = $_.Name
        $fullType = $_.Definition.Split(' ',2)[0]
        if ($fullType -match '\[\w+\]') {
            $typeSplit = ($fullType | Select-String -Pattern '([\w|\.]+)\[(\w+)\]' -AllMatches).Matches.Groups[1..2].Value
            $isList = $typeSplit[0] -match 'IList'
            $fullType = $typeSplit[1]
        }
        else {
            $isList = $fullType -match 'IList'
            $fullType = $fullType
        }
        $paramType = if ($isList) {
            "$fullType[]"
        }
        else {
            $fullType
        }
        if ($fullType -match '^Google\.') {
            Invoke-HelperFunctionGeneration -BaseType $fullType
        }
        $paramName = $_.Name
        $paramBlock += "        [parameter()]`n        [$paramType]`n        `$$paramName,"
        $paramHelpBlock += ".PARAMETER $paramName`n    Accepts the following type: $paramType`n"
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
    $outPath = Join-Path $OutputPath "$($fnName).ps1"
    Write-Verbose "Generating Helper function: $outPath"
    Set-Content -Path $outPath -Value $fnValue -Force
}
