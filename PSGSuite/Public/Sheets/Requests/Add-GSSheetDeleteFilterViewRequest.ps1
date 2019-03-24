function Add-GSSheetDeleteFilterViewRequest {
    <#
    .SYNOPSIS
    Creates a DeleteFilterViewRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a DeleteFilterViewRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER FilterId
    Accepts the following type: System.Nullable[int]

    .EXAMPLE
    Add-GSSheetDeleteFilterViewRequest -FilterId $filterId
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
        Write-Verbose "Adding DeleteFilterViewRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.DeleteFilterViewRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
            DeleteFilterView = $newRequest
        }
    }
}
