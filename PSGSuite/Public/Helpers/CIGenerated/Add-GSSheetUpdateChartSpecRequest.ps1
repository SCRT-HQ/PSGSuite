function Add-GSSheetUpdateChartSpecRequest {
    <#
    .SYNOPSIS
    Creates a UpdateChartSpecRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a UpdateChartSpecRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER ChartId
    Accepts the following type: [System.Nullable[int]].

    .PARAMETER Spec
    Accepts the following type: [Google.Apis.Sheets.v4.Data.ChartSpec].

    To create this type, use the function Add-GSSheetChartSpec or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.ChartSpec'.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSheetUpdateChartSpecRequest -ChartId $chartId -Spec $spec
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Nullable[int]]
        $ChartId,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ChartSpec]
        $Spec,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding UpdateChartSpecRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.UpdateChartSpecRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
                UpdateChartSpec = $newRequest
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
