function Invoke-BatchUpdateFunctionGeneration {
    [CmdletBinding()]
    Param (
        [parameter(Mandatory = $true,Position = 0)]
        [String]
        $BaseType
    )
    $OutputPath = [System.IO.Path]::Combine($PSScriptRoot,'..','PSGSuite','Public',$BaseType.Split('.')[2],'Requests')
    $TargetApi = $BaseType.Split('.')[2].TrimEnd('s')
    $req = New-Object $BaseType
    ($req | Get-Member -MemberType Property | Where-Object {$_.Name -ne 'ETag'}).Definition | ForEach-Object {
        $fullType = $_.Split(' ',2)[0]
        $requestType = $fullType.Split('.')[-1]
        $fnName = "Add-GS" + $TargetApi + $requestType
        $subType = New-Object $fullType
        $paramBlock = @()
        $paramHelpBlock = @()
        $exampleParamString = ""
        $subType | Get-Member -MemberType Property | Where-Object {$_.Name -ne 'ETag'} | ForEach-Object {
            $paramName = $_.Name
            $paramType = $_.Definition.Split(' ',2)[0]
            $paramBlock += "        [parameter()]`n        [$paramType]`n        `$$paramName,"
            $paramHelpBlock += ".PARAMETER $paramName`n    Accepts the following type: $paramType`n"
            $exampleParamString += " -$paramName `$$($paramName.Substring(0,1).ToLower())$($paramName.Substring(1))"
        }
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
        `$Requests
    }
    End {
        `$newRequest = New-Object '$fullType'
        foreach (`$prop in `$PSBoundParameters.Keys | Where-Object {`$newRequest.PSObject.Properties.Name -contains `$_}) {
            `$newRequest.`$prop = `$PSBoundParameters[`$prop]
        }
        New-Object '$BaseType' -Property @{
            $($requestType.TrimEnd('Request')) = `$newRequest
        }
    }
}
"@
        $outPath = Join-Path $OutputPath "$($fnName).ps1"
        Write-Verbose "Generating function: $outPath"
        Set-Content -Path $outPath -Value $fnValue -Force
    }
}
