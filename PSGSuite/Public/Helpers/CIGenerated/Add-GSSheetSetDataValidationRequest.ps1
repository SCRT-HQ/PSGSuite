function Add-GSSheetSetDataValidationRequest {
    <#
    .SYNOPSIS
    Creates a SetDataValidationRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a SetDataValidationRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Range
    Accepts the following type: Google.Apis.Sheets.v4.Data.GridRange.

    To create this type, use the function Add-GSSheetGridRange or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.GridRange'.

    .PARAMETER Rule
    Accepts the following type: Google.Apis.Sheets.v4.Data.DataValidationRule.

    To create this type, use the function Add-GSSheetDataValidationRule or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.DataValidationRule'.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSheetSetDataValidationRequest -Range $range -Rule $rule
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.GridRange]
        $Range,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.DataValidationRule]
        $Rule,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding SetDataValidationRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.SetDataValidationRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
                SetDataValidation = $newRequest
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
