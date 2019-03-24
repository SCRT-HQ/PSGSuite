function Add-GSSheetDuplicateFilterViewRequest {
    <#
    .SYNOPSIS
    Creates a DuplicateFilterViewRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a DuplicateFilterViewRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER FilterId
    Accepts the following type: System.Nullable[int]

    .EXAMPLE
    Add-GSSheetDuplicateFilterViewRequest -FilterId $filterId
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Nullable[int]]
        $FilterId,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding DuplicateFilterViewRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.DuplicateFilterViewRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
            DuplicateFilterView = $newRequest
        }
    }
}
