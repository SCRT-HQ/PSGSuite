function Add-GSSlideDeleteTextRequest {
    <#
    .SYNOPSIS
    Creates a DeleteTextRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a DeleteTextRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER CellLocation
    Accepts the following type: Google.Apis.Slides.v1.Data.TableCellLocation

    .PARAMETER ObjectId
    Accepts the following type: string

    .PARAMETER TextRange
    Accepts the following type: Google.Apis.Slides.v1.Data.Range

    .EXAMPLE
    Add-GSSlideDeleteTextRequest -CellLocation $cellLocation -ObjectId $objectId -TextRange $textRange
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Slides.v1.Data.TableCellLocation]
        $CellLocation,
        [parameter()]
        [string]
        $ObjectId,
        [parameter()]
        [Google.Apis.Slides.v1.Data.Range]
        $TextRange,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding DeleteTextRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.DeleteTextRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
            DeleteTex = $newRequest
        }
    }
}
