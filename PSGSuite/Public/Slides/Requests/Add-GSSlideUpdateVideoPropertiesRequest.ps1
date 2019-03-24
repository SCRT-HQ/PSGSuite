function Add-GSSlideUpdateVideoPropertiesRequest {
    <#
    .SYNOPSIS
    Creates a UpdateVideoPropertiesRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a UpdateVideoPropertiesRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER Fields
    Accepts the following type: System.Object

    .PARAMETER ObjectId
    Accepts the following type: string

    .PARAMETER VideoProperties
    Accepts the following type: Google.Apis.Slides.v1.Data.VideoProperties

    .EXAMPLE
    Add-GSSlideUpdateVideoPropertiesRequest -Fields $fields -ObjectId $objectId -VideoProperties $videoProperties
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
        [Google.Apis.Slides.v1.Data.VideoProperties]
        $VideoProperties,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding UpdateVideoPropertiesRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.UpdateVideoPropertiesRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
            UpdateVideoProperti = $newRequest
        }
    }
}
