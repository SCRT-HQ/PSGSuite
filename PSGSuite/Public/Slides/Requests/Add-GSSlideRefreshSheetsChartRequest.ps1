function Add-GSSlideRefreshSheetsChartRequest {
    <#
    .SYNOPSIS
    Creates a RefreshSheetsChartRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a RefreshSheetsChartRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER ObjectId
    Accepts the following type: string

    .EXAMPLE
    Add-GSSlideRefreshSheetsChartRequest -ObjectId $objectId
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $ObjectId,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding RefreshSheetsChartRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.RefreshSheetsChartRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
            RefreshSheetsChar = $newRequest
        }
    }
}
