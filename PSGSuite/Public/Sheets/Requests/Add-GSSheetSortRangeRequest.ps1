function Add-GSSheetSortRangeRequest {
    <#
    .SYNOPSIS
    Creates a SortRangeRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a SortRangeRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Range
    Accepts the following type: Google.Apis.Sheets.v4.Data.GridRange

    .PARAMETER SortSpecs
    Accepts the following type: System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.SortSpec]

    .EXAMPLE
    Add-GSSheetSortRangeRequest -Range $range -SortSpecs $sortSpecs
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.GridRange]
        $Range,
        [parameter()]
        [System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.SortSpec]]
        $SortSpecs,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding SortRangeRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.SortRangeRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
            SortRang = $newRequest
        }
    }
}
