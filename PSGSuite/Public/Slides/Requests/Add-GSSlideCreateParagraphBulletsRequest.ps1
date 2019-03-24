function Add-GSSlideCreateParagraphBulletsRequest {
    <#
    .SYNOPSIS
    Creates a CreateParagraphBulletsRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a CreateParagraphBulletsRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER BulletPreset
    Accepts the following type: string

    .PARAMETER CellLocation
    Accepts the following type: Google.Apis.Slides.v1.Data.TableCellLocation

    .PARAMETER ObjectId
    Accepts the following type: string

    .PARAMETER TextRange
    Accepts the following type: Google.Apis.Slides.v1.Data.Range

    .EXAMPLE
    Add-GSSlideCreateParagraphBulletsRequest -BulletPreset $bulletPreset -CellLocation $cellLocation -ObjectId $objectId -TextRange $textRange
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $BulletPreset,
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
        Write-Verbose "Adding CreateParagraphBulletsRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.CreateParagraphBulletsRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
            CreateParagraphBull = $newRequest
        }
    }
}
