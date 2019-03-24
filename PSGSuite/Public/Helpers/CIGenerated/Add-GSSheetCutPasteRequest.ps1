function Add-GSSheetCutPasteRequest {
    <#
    .SYNOPSIS
    Creates a CutPasteRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a CutPasteRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Destination
    Accepts the following type: Google.Apis.Sheets.v4.Data.GridCoordinate.

    To create this type, use the function Add-GSSheetGridCoordinate or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.GridCoordinate'.

    .PARAMETER PasteType
    Accepts the following type: string.

    .PARAMETER Source
    Accepts the following type: Google.Apis.Sheets.v4.Data.GridRange.

    To create this type, use the function Add-GSSheetGridRange or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.GridRange'.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSheetCutPasteRequest -Destination $destination -PasteType $pasteType -Source $source
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.GridCoordinate]
        $Destination,
        [parameter()]
        [string]
        $PasteType,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.GridRange]
        $Source,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding CutPasteRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.CutPasteRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
                CutPa = $newRequest
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
