function Add-GSSheetAddProtectedRangeRequest {
    <#
    .SYNOPSIS
    Creates a AddProtectedRangeRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a AddProtectedRangeRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER ProtectedRange
    Accepts the following type: Google.Apis.Sheets.v4.Data.ProtectedRange

    .EXAMPLE
    Add-GSSheetAddProtectedRangeRequest -ProtectedRange $protectedRange
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ProtectedRange]
        $ProtectedRange,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding AddProtectedRangeRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.AddProtectedRangeRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
            AddProtectedRang = $newRequest
        }
    }
}
