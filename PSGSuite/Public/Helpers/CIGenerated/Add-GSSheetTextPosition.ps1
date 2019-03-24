function Add-GSSheetTextPosition {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.TextPosition object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.TextPosition object.

    .PARAMETER HorizontalAlignment
    Accepts the following type: string

    .EXAMPLE
    Add-GSSheetTextPosition -HorizontalAlignment $horizontalAlignment
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.TextPosition')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $HorizontalAlignment,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.TextPosition[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.TextPosition'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.TextPosition'
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
