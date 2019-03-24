function Add-GSSheetPasteDataRequest {
    <#
    .SYNOPSIS
    Creates a PasteDataRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a PasteDataRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Coordinate
    Accepts the following type: Google.Apis.Sheets.v4.Data.GridCoordinate

    .PARAMETER Data
    Accepts the following type: string

    .PARAMETER Delimiter
    Accepts the following type: string

    .PARAMETER Html
    Accepts the following type: System.Nullable[bool]

    .PARAMETER Type
    Accepts the following type: string

    .EXAMPLE
    Add-GSSheetPasteDataRequest -Coordinate $coordinate -Data $data -Delimiter $delimiter -Html $html -Type $type
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.GridCoordinate]
        $Coordinate,
        [parameter()]
        [string]
        $Data,
        [parameter()]
        [string]
        $Delimiter,
        [parameter()]
        [System.Nullable[bool]]
        $Html,
        [parameter()]
        [string]
        $Type,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding PasteDataRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.PasteDataRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
            PasteData = $newRequest
        }
    }
}
