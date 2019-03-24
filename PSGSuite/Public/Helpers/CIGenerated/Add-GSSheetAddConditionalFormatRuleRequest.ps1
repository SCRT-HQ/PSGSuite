function Add-GSSheetAddConditionalFormatRuleRequest {
    <#
    .SYNOPSIS
    Creates a AddConditionalFormatRuleRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a AddConditionalFormatRuleRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Index
    Accepts the following type: System.Nullable[int].

    .PARAMETER Rule
    Accepts the following type: Google.Apis.Sheets.v4.Data.ConditionalFormatRule.

    To create this type, use the function Add-GSSheetConditionalFormatRule or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.ConditionalFormatRule'.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSheetAddConditionalFormatRuleRequest -Index $index -Rule $rule
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Nullable[int]]
        $Index,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ConditionalFormatRule]
        $Rule,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding AddConditionalFormatRuleRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.AddConditionalFormatRuleRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
                AddConditionalFormatRul = $newRequest
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
