function Add-GSSheetClearBasicFilterRequest {
    <#
    .SYNOPSIS
    Creates a ClearBasicFilterRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a ClearBasicFilterRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER SheetId
    Accepts the following type: System.Nullable[int]

    .EXAMPLE
    Add-GSSheetClearBasicFilterRequest -SheetId $sheetId
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Nullable[int]]
        $SheetId,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding ClearBasicFilterRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.ClearBasicFilterRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
            ClearBasicFilter = $newRequest
        }
    }
}
