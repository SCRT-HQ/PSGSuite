function Add-GSSheetMoveDimensionRequest {
    <#
    .SYNOPSIS
    Creates a MoveDimensionRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a MoveDimensionRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER DestinationIndex
    Accepts the following type: System.Nullable[int]

    .PARAMETER Source
    Accepts the following type: Google.Apis.Sheets.v4.Data.DimensionRange

    .EXAMPLE
    Add-GSSheetMoveDimensionRequest -DestinationIndex $destinationIndex -Source $source
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Nullable[int]]
        $DestinationIndex,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.DimensionRange]
        $Source,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding MoveDimensionRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.MoveDimensionRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
            MoveDimension = $newRequest
        }
    }
}
