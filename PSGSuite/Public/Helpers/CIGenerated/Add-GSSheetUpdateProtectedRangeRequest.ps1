function Add-GSSheetUpdateProtectedRangeRequest {
    <#
    .SYNOPSIS
    Creates a UpdateProtectedRangeRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a UpdateProtectedRangeRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Fields
    Accepts the following type: System.Object.

    .PARAMETER ProtectedRange
    Accepts the following type: Google.Apis.Sheets.v4.Data.ProtectedRange.

    To create this type, use the function Add-GSSheetProtectedRange or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.ProtectedRange'.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSheetUpdateProtectedRangeRequest -Fields $fields -ProtectedRange $protectedRange
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Object]
        $Fields,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ProtectedRange]
        $ProtectedRange,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding UpdateProtectedRangeRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.UpdateProtectedRangeRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
                UpdateProtectedRang = $newRequest
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
