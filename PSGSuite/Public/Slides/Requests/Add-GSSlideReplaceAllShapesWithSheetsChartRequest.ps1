function Add-GSSlideReplaceAllShapesWithSheetsChartRequest {
    <#
    .SYNOPSIS
    Creates a ReplaceAllShapesWithSheetsChartRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a ReplaceAllShapesWithSheetsChartRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER ChartId
    Accepts the following type: System.Nullable[int]

    .PARAMETER ContainsText
    Accepts the following type: Google.Apis.Slides.v1.Data.SubstringMatchCriteria

    .PARAMETER LinkingMode
    Accepts the following type: string

    .PARAMETER PageObjectIds
    Accepts the following type: System.Collections.Generic.IList[string]

    .PARAMETER SpreadsheetId
    Accepts the following type: string

    .EXAMPLE
    Add-GSSlideReplaceAllShapesWithSheetsChartRequest -ChartId $chartId -ContainsText $containsText -LinkingMode $linkingMode -PageObjectIds $pageObjectIds -SpreadsheetId $spreadsheetId
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Nullable[int]]
        $ChartId,
        [parameter()]
        [Google.Apis.Slides.v1.Data.SubstringMatchCriteria]
        $ContainsText,
        [parameter()]
        [string]
        $LinkingMode,
        [parameter()]
        [System.Collections.Generic.IList[string]]
        $PageObjectIds,
        [parameter()]
        [string]
        $SpreadsheetId,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding ReplaceAllShapesWithSheetsChartRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.ReplaceAllShapesWithSheetsChartRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
            ReplaceAllShapesWithSheetsChar = $newRequest
        }
    }
}
