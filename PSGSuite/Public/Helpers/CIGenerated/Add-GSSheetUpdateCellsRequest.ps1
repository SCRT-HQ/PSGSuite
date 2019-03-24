function Add-GSSheetUpdateCellsRequest {
    <#
    .SYNOPSIS
    Creates a UpdateCellsRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a UpdateCellsRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Fields
    Accepts the following type: [System.Object].

    .PARAMETER Range
    Accepts the following type: [Google.Apis.Sheets.v4.Data.GridRange].

    To create this type, use the function Add-GSSheetGridRange or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.GridRange'.

    .PARAMETER Rows
    Accepts the following type: [System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.RowData]].

    .PARAMETER Start
    Accepts the following type: [Google.Apis.Sheets.v4.Data.GridCoordinate].

    To create this type, use the function Add-GSSheetGridCoordinate or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.GridCoordinate'.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSheetUpdateCellsRequest -Fields $fields -Range $range -Rows $rows -Start $start
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Object]
        $Fields,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.GridRange]
        $Range,
        [parameter()]
        [System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.RowData]]
        $Rows,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.GridCoordinate]
        $Start,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding UpdateCellsRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.UpdateCellsRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
                UpdateCell = $newRequest
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
