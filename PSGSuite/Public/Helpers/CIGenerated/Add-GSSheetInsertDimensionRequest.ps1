function Add-GSSheetInsertDimensionRequest {
    <#
    .SYNOPSIS
    Creates a InsertDimensionRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a InsertDimensionRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER InheritFromBefore
    Accepts the following type: [System.Nullable[bool]].

    .PARAMETER Range
    Accepts the following type: [Google.Apis.Sheets.v4.Data.DimensionRange].

    To create this type, use the function Add-GSSheetDimensionRange or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.DimensionRange'.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSheetInsertDimensionRequest -InheritFromBefore $inheritFromBefore -Range $range
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Nullable[bool]]
        $InheritFromBefore,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.DimensionRange]
        $Range,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding InsertDimensionRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.InsertDimensionRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
                InsertDimension = $newRequest
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
