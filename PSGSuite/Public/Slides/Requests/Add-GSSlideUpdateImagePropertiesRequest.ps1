function Add-GSSlideUpdateImagePropertiesRequest {
    <#
    .SYNOPSIS
    Creates a UpdateImagePropertiesRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a UpdateImagePropertiesRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER Fields
    Accepts the following type: System.Object

    .PARAMETER ImageProperties
    Accepts the following type: Google.Apis.Slides.v1.Data.ImageProperties

    .PARAMETER ObjectId
    Accepts the following type: string

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
        New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
            UpdateImageProperti = $newRequest
        }
    }
}
