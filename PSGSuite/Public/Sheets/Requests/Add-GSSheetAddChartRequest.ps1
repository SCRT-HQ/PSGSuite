function Add-GSSheetAddChartRequest {
    <#
    .SYNOPSIS
    Creates a AddChartRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a AddChartRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Chart
    Accepts the following type: Google.Apis.Sheets.v4.Data.EmbeddedChart

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
        New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
            AddChar = $newRequest
        }
    }
}
