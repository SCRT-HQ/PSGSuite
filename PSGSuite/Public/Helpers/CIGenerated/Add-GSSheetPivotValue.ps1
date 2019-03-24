function Add-GSSheetPivotValue {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.PivotValue object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.PivotValue object.

    .PARAMETER CalculatedDisplayType
    Accepts the following type: [string].

    .PARAMETER Formula
    Accepts the following type: [string].

    .PARAMETER Name
    Accepts the following type: [string].

    .PARAMETER SourceColumnOffset
    Accepts the following type: [int].

    .PARAMETER SummarizeFunction
    Accepts the following type: [string].

    .EXAMPLE
    Add-GSSheetPivotValue -CalculatedDisplayType $calculatedDisplayType -Formula $formula -Name $name -SourceColumnOffset $sourceColumnOffset -SummarizeFunction $summarizeFunction
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.PivotValue')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $CalculatedDisplayType,
        [parameter()]
        [string]
        $Formula,
        [parameter()]
        [string]
        $Name,
        [parameter()]
        [int]
        $SourceColumnOffset,
        [parameter()]
        [string]
        $SummarizeFunction,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.PivotValue[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.PivotValue'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.PivotValue'
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
