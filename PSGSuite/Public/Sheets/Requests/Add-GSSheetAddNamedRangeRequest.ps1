function Add-GSSheetAddNamedRangeRequest {
    <#
    .SYNOPSIS
    Creates a AddNamedRangeRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a AddNamedRangeRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER NamedRange
    Accepts the following type: Google.Apis.Sheets.v4.Data.NamedRange

    .EXAMPLE
    Add-GSSheetAddNamedRangeRequest -NamedRange $namedRange
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.NamedRange]
        $NamedRange,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding AddNamedRangeRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.AddNamedRangeRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
            AddNamedRang = $newRequest
        }
    }
}
