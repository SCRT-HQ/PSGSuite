function Add-GSSheetAddConditionalFormatRuleRequest {
    <#
    .SYNOPSIS
    Creates a AddConditionalFormatRuleRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a AddConditionalFormatRuleRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Index
    Accepts the following type: System.Nullable[int]

    .PARAMETER Rule
    Accepts the following type: Google.Apis.Sheets.v4.Data.ConditionalFormatRule

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
        New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
            AddConditionalFormatRul = $newRequest
        }
    }
}
