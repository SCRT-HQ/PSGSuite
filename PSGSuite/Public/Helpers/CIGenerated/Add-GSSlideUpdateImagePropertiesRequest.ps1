function Add-GSSlideUpdateImagePropertiesRequest {
    <#
    .SYNOPSIS
    Creates a UpdateImagePropertiesRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a UpdateImagePropertiesRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER Fields
    Accepts the following type: [System.Object].

    .PARAMETER ImageProperties
    Accepts the following type: [Google.Apis.Slides.v1.Data.ImageProperties].

    To create this type, use the function Add-GSSlideImageProperties or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.ImageProperties'.

    .PARAMETER ObjectId
    Accepts the following type: [string].

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSlideUpdateImagePropertiesRequest -Fields $fields -ImageProperties $imageProperties -ObjectId $objectId
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Object]
        $Fields,
        [parameter()]
        [Google.Apis.Slides.v1.Data.ImageProperties]
        $ImageProperties,
        [parameter()]
        [string]
        $ObjectId,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding UpdateImagePropertiesRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.UpdateImagePropertiesRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
                UpdateImageProperti = $newRequest
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
