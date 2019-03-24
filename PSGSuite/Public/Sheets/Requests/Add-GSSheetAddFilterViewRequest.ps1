function Add-GSSheetAddFilterViewRequest {
    <#
    .SYNOPSIS
    Creates a AddFilterViewRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a AddFilterViewRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Filter
    Accepts the following type: Google.Apis.Sheets.v4.Data.FilterView

    .EXAMPLE
    Add-GSSheetAddFilterViewRequest -Filter $filter
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.FilterView]
        $Filter,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding AddFilterViewRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.AddFilterViewRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
            AddFilterView = $newRequest
        }
    }
}
