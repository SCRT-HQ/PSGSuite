function Add-GSSheetUpdateBordersRequest {
    <#
    .SYNOPSIS
    Creates a UpdateBordersRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a UpdateBordersRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Bottom
    Accepts the following type: Google.Apis.Sheets.v4.Data.Border.

    To create this type, use the function Add-GSSheetBorder or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.Border'.

    .PARAMETER InnerHorizontal
    Accepts the following type: Google.Apis.Sheets.v4.Data.Border.

    To create this type, use the function Add-GSSheetBorder or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.Border'.

    .PARAMETER InnerVertical
    Accepts the following type: Google.Apis.Sheets.v4.Data.Border.

    To create this type, use the function Add-GSSheetBorder or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.Border'.

    .PARAMETER Left
    Accepts the following type: Google.Apis.Sheets.v4.Data.Border.

    To create this type, use the function Add-GSSheetBorder or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.Border'.

    .PARAMETER Range
    Accepts the following type: Google.Apis.Sheets.v4.Data.GridRange.

    To create this type, use the function Add-GSSheetGridRange or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.GridRange'.

    .PARAMETER Right
    Accepts the following type: Google.Apis.Sheets.v4.Data.Border.

    To create this type, use the function Add-GSSheetBorder or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.Border'.

    .PARAMETER Top
    Accepts the following type: Google.Apis.Sheets.v4.Data.Border.

    To create this type, use the function Add-GSSheetBorder or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.Border'.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSheetUpdateBordersRequest -Bottom $bottom -InnerHorizontal $innerHorizontal -InnerVertical $innerVertical -Left $left -Range $range -Right $right -Top $top
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Border]
        $Bottom,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Border]
        $InnerHorizontal,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Border]
        $InnerVertical,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Border]
        $Left,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.GridRange]
        $Range,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Border]
        $Right,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Border]
        $Top,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding UpdateBordersRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.UpdateBordersRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
                UpdateBorder = $newRequest
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
