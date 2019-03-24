function Add-GSSheetUpdateBandingRequest {
    <#
    .SYNOPSIS
    Creates a UpdateBandingRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a UpdateBandingRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER BandedRange
    Accepts the following type: Google.Apis.Sheets.v4.Data.BandedRange

    .PARAMETER Fields
    Accepts the following type: System.Object

    .EXAMPLE
    Add-GSSheetUpdateBandingRequest -BandedRange $bandedRange -Fields $fields
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.BandedRange]
        $BandedRange,
        [parameter()]
        [System.Object]
        $Fields,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding UpdateBandingRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.UpdateBandingRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
            UpdateBanding = $newRequest
        }
    }
}
