function Add-GSSheetDeleteNamedRangeRequest {
    <#
    .SYNOPSIS
    Creates a DeleteNamedRangeRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a DeleteNamedRangeRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER NamedRangeId
    Accepts the following type: string.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSheetDeleteNamedRangeRequest -NamedRangeId $namedRangeId
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $NamedRangeId,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding DeleteNamedRangeRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.DeleteNamedRangeRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
                DeleteNamedRang = $newRequest
            }
        }
        catch {
            if ($ErrorActionPreference -eq 'Stop') {
                $PSCmdlet.ThrowTerminatingError($_)
            }
            else {
                Write-Error $_
            }
        }
    }
}
