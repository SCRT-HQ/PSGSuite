function Add-GSSheetDeleteProtectedRangeRequest {
    <#
    .SYNOPSIS
    Creates a DeleteProtectedRangeRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a DeleteProtectedRangeRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER ProtectedRangeId
    Accepts the following type: System.Nullable[int]

    .EXAMPLE
    Add-GSSheetDeleteProtectedRangeRequest -ProtectedRangeId $protectedRangeId
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Nullable[int]]
        $ProtectedRangeId,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding DeleteProtectedRangeRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.DeleteProtectedRangeRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
            DeleteProtectedRang = $newRequest
        }
    }
}
