function Invoke-HelperFunctionGeneration {
    [CmdletBinding()]
    Param (
        [parameter(Mandatory = $true,Position = 0)]
        [String]
        $BaseType = 'Google.Apis.Sheets.v4.Data.BandedRange'
    )
    $TargetApi = $BaseType.Split('.')[2].TrimEnd('s')
    $OutputPath = [System.IO.Path]::Combine($PSScriptRoot,'..','PSGSuite','Public','Helpers')
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
function Add-GSUserPhone {
    <#
    .SYNOPSIS
    Builds a UserPhone object to use when creating or updating a User

    .DESCRIPTION
    Builds a UserPhone object to use when creating or updating a User

    .PARAMETER CustomType
    If the value of type is custom, this property contains the custom type

    .PARAMETER Primary
    Indicates if this is the user's primary phone number. A user may only have one primary phone number

    .PARAMETER Type
    The type of phone number.

    Acceptable values are:
    * "assistant"
    * "callback"
    * "car"
    * "company_main"
    * "custom"
    * "grand_central"
    * "home"
    * "home_fax"
    * "isdn"
    * "main"
    * "mobile"
    * "other"
    * "other_fax"
    * "pager"
    * "radio"
    * "telex"
    * "tty_tdd"
    * "work"
    * "work_fax"
    * "work_mobile"
    * "work_pager"

    .PARAMETER Value
    A human-readable phone number. It may be in any telephone number format

    .PARAMETER InputObject
    Used for pipeline input of an existing UserPhone object to strip the extra attributes and prevent errors

    .EXAMPLE

    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $CustomType,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [Switch]
        $Primary,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [ValidateSet('assistant', 'callback', 'car', 'company_main', 'custom', 'grand_central', 'home', 'home_fax', 'isdn', 'main', 'mobile', 'other', 'other_fax', 'pager', 'radio', 'telex', 'tty_tdd', 'work', 'work_fax', 'work_mobile', 'work_pager')]
        [String]
        $Type,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [Alias('Phone')]
        [String]
        $Value,
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = "InputObject")]
        [Google.Apis.Admin.Directory.directory_v1.Data.UserAddress[]]
        $InputObject
    )
    Begin {
        $propsToWatch = @(
            'CustomType'
            'Type'
            'Value'
        )
    }
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.UserPhone'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        $obj.$prop = $PSBoundParameters[$prop]
                    }
                    $obj
                }
                InputObject {
                    foreach ($iObj in $InputObject) {
                        $obj = New-Object 'Google.Apis.Admin.Directory.directory_v1.Data.UserPhone'
                        foreach ($prop in $iObj.PSObject.Properties.Name | Where-Object {$obj.PSObject.Properties.Name -contains $_ -and $propsToWatch -contains $_}) {
                            $obj.$prop = $iObj.$prop
                        }
                        $obj
                    }
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
"@
        $outPath = Join-Path $OutputPath "$($fnName).ps1"
        Write-Verbose "Generating function: $outPath"
        Set-Content -Path $outPath -Value $fnValue -Force
    }
}
