function Add-GSSlideUpdateShapePropertiesRequest {
    <#
    .SYNOPSIS
    Creates a UpdateShapePropertiesRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a UpdateShapePropertiesRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER Fields
    Accepts the following type: System.Object.

    .PARAMETER ObjectId
    Accepts the following type: string.

    .PARAMETER ShapeProperties
    Accepts the following type: Google.Apis.Slides.v1.Data.ShapeProperties.

    To create this type, use the function Add-GSSlideShapeProperties or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.ShapeProperties'.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSlideUpdateShapePropertiesRequest -Fields $fields -ObjectId $objectId -ShapeProperties $shapeProperties
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Object]
        $Fields,
        [parameter()]
        [string]
        $ObjectId,
        [parameter()]
        [Google.Apis.Slides.v1.Data.ShapeProperties]
        $ShapeProperties,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding UpdateShapePropertiesRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.UpdateShapePropertiesRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
                UpdateShapeProperti = $newRequest
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
