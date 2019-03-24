function Add-GSSheetRepeatCellRequest {
    <#
    .SYNOPSIS
    Creates a RepeatCellRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a RepeatCellRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Cell
    Accepts the following type: Google.Apis.Sheets.v4.Data.CellData

    .PARAMETER Fields
    Accepts the following type: System.Object

    .PARAMETER Range
    Accepts the following type: Google.Apis.Sheets.v4.Data.GridRange

    .EXAMPLE
    Add-GSSheetRepeatCellRequest -Cell $cell -Fields $fields -Range $range
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.CellData]
        $Cell,
        [parameter()]
        [System.Object]
        $Fields,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.GridRange]
        $Range,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding RepeatCellRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.RepeatCellRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
            RepeatCell = $newRequest
        }
    }
}
