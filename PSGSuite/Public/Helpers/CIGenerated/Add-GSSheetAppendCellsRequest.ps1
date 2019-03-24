function Add-GSSheetAppendCellsRequest {
    <#
    .SYNOPSIS
    Creates a AppendCellsRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a AppendCellsRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Fields
    Accepts the following type: System.Object.

    .PARAMETER Rows
    Accepts the following type: System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.RowData].

    .PARAMETER SheetId
    Accepts the following type: System.Nullable[int].

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSheetAppendCellsRequest -Fields $fields -Rows $rows -SheetId $sheetId
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Object]
        $Fields,
        [parameter()]
        [System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.RowData]]
        $Rows,
        [parameter()]
        [System.Nullable[int]]
        $SheetId,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding AppendCellsRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.AppendCellsRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
                AppendCell = $newRequest
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
