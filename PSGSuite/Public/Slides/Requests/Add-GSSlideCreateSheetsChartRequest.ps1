function Add-GSSlideCreateSheetsChartRequest {
    <#
    .SYNOPSIS
    Creates a CreateSheetsChartRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a CreateSheetsChartRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER ChartId
    Accepts the following type: System.Nullable[int]

    .PARAMETER ElementProperties
    Accepts the following type: Google.Apis.Slides.v1.Data.PageElementProperties

    .PARAMETER LinkingMode
    Accepts the following type: string

    .PARAMETER ObjectId
    Accepts the following type: string

    .PARAMETER SpreadsheetId
    Accepts the following type: string

    .EXAMPLE
    Add-GSSlideCreateSheetsChartRequest -ChartId $chartId -ElementProperties $elementProperties -LinkingMode $linkingMode -ObjectId $objectId -SpreadsheetId $spreadsheetId
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Nullable[int]]
        $ChartId,
        [parameter()]
        [Google.Apis.Slides.v1.Data.PageElementProperties]
        $ElementProperties,
        [parameter()]
        [string]
        $LinkingMode,
        [parameter()]
        [string]
        $ObjectId,
        [parameter()]
        [string]
        $SpreadsheetId,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding CreateSheetsChartRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.CreateSheetsChartRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
            CreateSheetsChar = $newRequest
        }
    }
}
