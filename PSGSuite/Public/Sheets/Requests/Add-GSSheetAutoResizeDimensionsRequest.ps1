function Add-GSSheetAutoResizeDimensionsRequest {
    <#
    .SYNOPSIS
    Creates a AutoResizeDimensionsRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a AutoResizeDimensionsRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Dimensions
    Accepts the following type: Google.Apis.Sheets.v4.Data.DimensionRange

    .EXAMPLE
    Add-GSSheetAutoResizeDimensionsRequest -Dimensions $dimensions
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.DimensionRange]
        $Dimensions,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding AutoResizeDimensionsRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.AutoResizeDimensionsRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
            AutoResizeDimension = $newRequest
        }
    }
}
