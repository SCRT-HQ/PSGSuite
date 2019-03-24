function Add-GSSlideCreateShapeRequest {
    <#
    .SYNOPSIS
    Creates a CreateShapeRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a CreateShapeRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER ElementProperties
    Accepts the following type: Google.Apis.Slides.v1.Data.PageElementProperties

    .PARAMETER ObjectId
    Accepts the following type: string

    .PARAMETER ShapeType
    Accepts the following type: string

    .EXAMPLE
    Add-GSSlideCreateShapeRequest -ElementProperties $elementProperties -ObjectId $objectId -ShapeType $shapeType
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Slides.v1.Data.PageElementProperties]
        $ElementProperties,
        [parameter()]
        [string]
        $ObjectId,
        [parameter()]
        [string]
        $ShapeType,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding CreateShapeRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.CreateShapeRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
            CreateShap = $newRequest
        }
    }
}
