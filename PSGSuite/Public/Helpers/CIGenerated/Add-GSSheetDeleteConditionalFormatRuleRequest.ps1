function Add-GSSheetDeleteConditionalFormatRuleRequest {
    <#
    .SYNOPSIS
    Creates a DeleteConditionalFormatRuleRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a DeleteConditionalFormatRuleRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Index
    Accepts the following type: System.Nullable[int].

    .PARAMETER SheetId
    Accepts the following type: System.Nullable[int].

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSheetDeleteConditionalFormatRuleRequest -Index $index -SheetId $sheetId
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Nullable[int]]
        $Index,
        [parameter()]
        [System.Nullable[int]]
        $SheetId,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding DeleteConditionalFormatRuleRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.DeleteConditionalFormatRuleRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
                DeleteConditionalFormatRul = $newRequest
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
