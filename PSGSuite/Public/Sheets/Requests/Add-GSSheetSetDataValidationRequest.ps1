function Add-GSSheetSetDataValidationRequest {
    <#
    .SYNOPSIS
    Creates a SetDataValidationRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a SetDataValidationRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Range
    Accepts the following type: Google.Apis.Sheets.v4.Data.GridRange

    .PARAMETER Rule
    Accepts the following type: Google.Apis.Sheets.v4.Data.DataValidationRule

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
        New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
            SetDataValidation = $newRequest
        }
    }
}
