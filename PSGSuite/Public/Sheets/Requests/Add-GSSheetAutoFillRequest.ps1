function Add-GSSheetAutoFillRequest {
    <#
    .SYNOPSIS
    Creates a AutoFillRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a AutoFillRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Range
    Accepts the following type: Google.Apis.Sheets.v4.Data.GridRange

    .PARAMETER SourceAndDestination
    Accepts the following type: Google.Apis.Sheets.v4.Data.SourceAndDestination

    .PARAMETER UseAlternateSeries
    Accepts the following type: System.Nullable[bool]

    .EXAMPLE
    Add-GSSheetAutoFillRequest -Range $range -SourceAndDestination $sourceAndDestination -UseAlternateSeries $useAlternateSeries
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.GridRange]
        $Range,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.SourceAndDestination]
        $SourceAndDestination,
        [parameter()]
        [System.Nullable[bool]]
        $UseAlternateSeries,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding AutoFillRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.AutoFillRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
            AutoFill = $newRequest
        }
    }
}
