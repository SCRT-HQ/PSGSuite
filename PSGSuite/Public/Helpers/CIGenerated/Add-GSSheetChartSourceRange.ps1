function Add-GSSheetChartSourceRange {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.ChartSourceRange object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.ChartSourceRange object.

    .PARAMETER Sources
    Accepts the following type: System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.GridRange][]

    .EXAMPLE
    Add-GSSheetChartSourceRange -Sources $sources
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.ChartSourceRange')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.GridRange][]]
        $Sources,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.ChartSourceRange[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.ChartSourceRange'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        switch ($prop) {
                            Sources {
                                $list = New-Object 'System.Collections.Generic.List[System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.GridRange]]'
                                foreach ($item in $Sources) {
                                    $list.Add($item)
                                }
                                $obj.Sources = $list
                            }
                            default {
                                $obj.$prop = $PSBoundParameters[$prop]
                            }
                        }
                    }
                    $obj
                }
                InputObject {
                    foreach ($iObj in $InputObject) {
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.ChartSourceRange'
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
