function Add-GSSlideCreateShapeRequest {
    <#
    .SYNOPSIS
    Creates a CreateShapeRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a CreateShapeRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER ElementProperties
    Accepts the following type: Google.Apis.Slides.v1.Data.PageElementProperties.

    To create this type, use the function Add-GSSlidePageElementProperties or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.PageElementProperties'.

    .PARAMETER ObjectId
    Accepts the following type: string.

    .PARAMETER ShapeType
    Accepts the following type: string.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

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
        try {
            New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
                CreateShap = $newRequest
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
