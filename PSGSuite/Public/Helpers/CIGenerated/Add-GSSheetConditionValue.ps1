function Add-GSSheetConditionValue {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.ConditionValue object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.ConditionValue object.

    .PARAMETER RelativeDate
    Accepts the following type: [string].

    .PARAMETER UserEnteredValue
    Accepts the following type: [string].

    .EXAMPLE
    Add-GSSheetConditionValue -RelativeDate $relativeDate -UserEnteredValue $userEnteredValue
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.ConditionValue')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $RelativeDate,
        [parameter()]
        [string]
        $UserEnteredValue,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.ConditionValue[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.ConditionValue'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        switch ($prop) {
                            default {
                                $obj.$prop = $PSBoundParameters[$prop]
                            }
                        }
                    }
                    $obj
                }
                InputObject {
                    foreach ($iObj in $InputObject) {
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.ConditionValue'
                        foreach ($prop in $iObj.PSObject.Properties.Name | Where-Object {$obj.PSObject.Properties.Name -contains $_ -and $_ -ne 'ETag'}) {
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
