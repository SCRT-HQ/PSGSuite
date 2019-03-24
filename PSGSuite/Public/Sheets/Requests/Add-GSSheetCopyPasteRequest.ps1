function Add-GSSheetCopyPasteRequest {
    <#
    .SYNOPSIS
    Creates a CopyPasteRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a CopyPasteRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Destination
    Accepts the following type: Google.Apis.Sheets.v4.Data.GridRange

    .PARAMETER PasteOrientation
    Accepts the following type: string

    .PARAMETER PasteType
    Accepts the following type: string

    .PARAMETER Source
    Accepts the following type: Google.Apis.Sheets.v4.Data.GridRange

    .EXAMPLE
    Add-GSSheetCopyPasteRequest -Destination $destination -PasteOrientation $pasteOrientation -PasteType $pasteType -Source $source
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.GridRange]
        $Destination,
        [parameter()]
        [string]
        $PasteOrientation,
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
        Write-Verbose "Adding CopyPasteRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.CopyPasteRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
            CopyPa = $newRequest
        }
    }
}
