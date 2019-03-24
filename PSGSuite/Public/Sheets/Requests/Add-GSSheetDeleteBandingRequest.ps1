function Add-GSSheetDeleteBandingRequest {
    <#
    .SYNOPSIS
    Creates a DeleteBandingRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a DeleteBandingRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER BandedRangeId
    Accepts the following type: System.Nullable[int]

    .EXAMPLE
    Add-GSSheetDeleteBandingRequest -BandedRangeId $bandedRangeId
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Nullable[int]]
        $BandedRangeId,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding DeleteBandingRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.DeleteBandingRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
            DeleteBanding = $newRequest
        }
    }
}
