function Add-GSSheetBandingProperties {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.BandingProperties object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.BandingProperties object.

    .PARAMETER FirstBandColor
    Accepts the following type: Google.Apis.Sheets.v4.Data.Color

    .PARAMETER FooterColor
    Accepts the following type: Google.Apis.Sheets.v4.Data.Color

    .PARAMETER HeaderColor
    Accepts the following type: Google.Apis.Sheets.v4.Data.Color

    .PARAMETER SecondBandColor
    Accepts the following type: Google.Apis.Sheets.v4.Data.Color

    .EXAMPLE
    Add-GSSheetBandingProperties -FirstBandColor $firstBandColor -FooterColor $footerColor -HeaderColor $headerColor -SecondBandColor $secondBandColor
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.BandingProperties')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Color]
        $FirstBandColor,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Color]
        $FooterColor,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Color]
        $HeaderColor,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Color]
        $SecondBandColor,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.BandingProperties[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.BandingProperties'
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.BandingProperties'
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
