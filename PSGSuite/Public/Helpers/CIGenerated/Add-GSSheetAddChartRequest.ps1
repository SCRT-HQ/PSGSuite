function Add-GSSheetAddChartRequest {
    <#
    .SYNOPSIS
    Creates a AddChartRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a AddChartRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Chart
    Accepts the following type: Google.Apis.Sheets.v4.Data.EmbeddedChart.

    To create this type, use the function Add-GSSheetEmbeddedChart or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.EmbeddedChart'.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSheetAddChartRequest -Chart $chart
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.EmbeddedChart]
        $Chart,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding AddChartRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.AddChartRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
                AddChar = $newRequest
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
