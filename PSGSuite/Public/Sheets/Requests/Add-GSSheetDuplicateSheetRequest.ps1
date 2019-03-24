function Add-GSSheetDuplicateSheetRequest {
    <#
    .SYNOPSIS
    Creates a DuplicateSheetRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a DuplicateSheetRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER InsertSheetIndex
    Accepts the following type: System.Nullable[int]

    .PARAMETER NewSheetId
    Accepts the following type: System.Nullable[int]

    .PARAMETER NewSheetName
    Accepts the following type: string

    .PARAMETER SourceSheetId
    Accepts the following type: System.Nullable[int]

    .EXAMPLE
    Add-GSSheetDuplicateSheetRequest -InsertSheetIndex $insertSheetIndex -NewSheetId $newSheetId -NewSheetName $newSheetName -SourceSheetId $sourceSheetId
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Nullable[int]]
        $InsertSheetIndex,
        [parameter()]
        [System.Nullable[int]]
        $NewSheetId,
        [parameter()]
        [string]
        $NewSheetName,
        [parameter()]
        [System.Nullable[int]]
        $SourceSheetId,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding DuplicateSheetRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.DuplicateSheetRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
            DuplicateSh = $newRequest
        }
    }
}
