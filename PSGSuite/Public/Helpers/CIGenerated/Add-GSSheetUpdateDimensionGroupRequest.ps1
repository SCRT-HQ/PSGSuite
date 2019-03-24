function Add-GSSheetUpdateDimensionGroupRequest {
    <#
    .SYNOPSIS
    Creates a UpdateDimensionGroupRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a UpdateDimensionGroupRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER DimensionGroup
    Accepts the following type: [Google.Apis.Sheets.v4.Data.DimensionGroup].

    To create this type, use the function Add-GSSheetDimensionGroup or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.DimensionGroup'.

    .PARAMETER Fields
    Accepts the following type: [System.Object].

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSheetUpdateDimensionGroupRequest -DimensionGroup $dimensionGroup -Fields $fields
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.DimensionGroup]
        $DimensionGroup,
        [parameter()]
        [System.Object]
        $Fields,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding UpdateDimensionGroupRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.UpdateDimensionGroupRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
                UpdateDimensionGroup = $newRequest
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
