function Add-GSSlideUpdateParagraphStyleRequest {
    <#
    .SYNOPSIS
    Creates a UpdateParagraphStyleRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a UpdateParagraphStyleRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER CellLocation
    Accepts the following type: Google.Apis.Slides.v1.Data.TableCellLocation

    .PARAMETER Fields
    Accepts the following type: System.Object

    .PARAMETER ObjectId
    Accepts the following type: string

    .PARAMETER Style
    Accepts the following type: Google.Apis.Slides.v1.Data.ParagraphStyle

    .PARAMETER TextRange
    Accepts the following type: Google.Apis.Slides.v1.Data.Range

    .EXAMPLE
    Add-GSSlideUpdateParagraphStyleRequest -CellLocation $cellLocation -Fields $fields -ObjectId $objectId -Style $style -TextRange $textRange
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Slides.v1.Data.TableCellLocation]
        $CellLocation,
        [parameter()]
        [System.Object]
        $Fields,
        [parameter()]
        [string]
        $ObjectId,
        [parameter()]
        [Google.Apis.Slides.v1.Data.ParagraphStyle]
        $Style,
        [parameter()]
        [Google.Apis.Slides.v1.Data.Range]
        $TextRange,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding UpdateParagraphStyleRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.UpdateParagraphStyleRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
            UpdateParagraphStyl = $newRequest
        }
    }
}
