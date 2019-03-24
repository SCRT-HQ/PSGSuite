function Add-GSSheetBasicChartDomain {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.BasicChartDomain object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.BasicChartDomain object.

    .PARAMETER Domain
    Accepts the following type: [Google.Apis.Sheets.v4.Data.ChartData].

    To create this type, use the function Add-GSSheetChartData or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.ChartData'.

    .PARAMETER Reversed
    Accepts the following type: [switch].

    .EXAMPLE
    Add-GSSheetBasicChartDomain -Domain $domain -Reversed $reversed
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.BasicChartDomain')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ChartData]
        $Domain,
        [parameter()]
        [switch]
        $Reversed,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.BasicChartDomain[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.BasicChartDomain'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.BasicChartDomain'
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
