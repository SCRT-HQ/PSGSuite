function Add-GSSheetDeleteRangeRequest {
    <#
    .SYNOPSIS
    Creates a DeleteRangeRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a DeleteRangeRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Range
    Accepts the following type: Google.Apis.Sheets.v4.Data.GridRange.

    To create this type, use the function Add-GSSheetGridRange or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.GridRange'.

    .PARAMETER ShiftDimension
    Accepts the following type: string.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSheetDeleteRangeRequest -Range $range -ShiftDimension $shiftDimension
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.GridRange]
        $Range,
        [parameter()]
        [string]
        $ShiftDimension,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding DeleteRangeRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.DeleteRangeRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
                DeleteRang = $newRequest
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
