function Add-GSSheetUpdateConditionalFormatRuleRequest {
    <#
    .SYNOPSIS
    Creates a UpdateConditionalFormatRuleRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a UpdateConditionalFormatRuleRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Index
    Accepts the following type: System.Nullable[int].

    .PARAMETER NewIndex
    Accepts the following type: System.Nullable[int].

    .PARAMETER Rule
    Accepts the following type: Google.Apis.Sheets.v4.Data.ConditionalFormatRule.

    To create this type, use the function Add-GSSheetConditionalFormatRule or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.ConditionalFormatRule'.

    .PARAMETER SheetId
    Accepts the following type: System.Nullable[int].

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSheetUpdateConditionalFormatRuleRequest -Index $index -NewIndex $newIndex -Rule $rule -SheetId $sheetId
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Nullable[int]]
        $Index,
        [parameter()]
        [System.Nullable[int]]
        $NewIndex,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ConditionalFormatRule]
        $Rule,
        [parameter()]
        [System.Nullable[int]]
        $SheetId,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding UpdateConditionalFormatRuleRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.UpdateConditionalFormatRuleRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
                UpdateConditionalFormatRul = $newRequest
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
