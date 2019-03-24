function Add-GSSheetAutoResizeDimensionsRequest {
    <#
    .SYNOPSIS
    Creates a AutoResizeDimensionsRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a AutoResizeDimensionsRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Dimensions
    Accepts the following type: [Google.Apis.Sheets.v4.Data.DimensionRange].

    To create this type, use the function Add-GSSheetDimensionRange or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.DimensionRange'.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSheetAutoResizeDimensionsRequest -Dimensions $dimensions
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.DimensionRange]
        $Dimensions,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding AutoResizeDimensionsRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.AutoResizeDimensionsRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
                AutoResizeDimension = $newRequest
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
