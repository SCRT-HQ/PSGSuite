function Add-GSSheetAppendDimensionRequest {
    <#
    .SYNOPSIS
    Creates a AppendDimensionRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a AppendDimensionRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Dimension
    Accepts the following type: [string].

    .PARAMETER Length
    Accepts the following type: [System.Nullable[int]].

    .PARAMETER SheetId
    Accepts the following type: [System.Nullable[int]].

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSheetAppendDimensionRequest -Dimension $dimension -Length $length -SheetId $sheetId
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $Dimension,
        [parameter()]
        [System.Nullable[int]]
        $Length,
        [parameter()]
        [System.Nullable[int]]
        $SheetId,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding AppendDimensionRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.AppendDimensionRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
                AppendDimension = $newRequest
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
