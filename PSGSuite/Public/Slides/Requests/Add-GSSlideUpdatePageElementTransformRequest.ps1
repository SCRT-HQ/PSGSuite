function Add-GSSlideUpdatePageElementTransformRequest {
    <#
    .SYNOPSIS
    Creates a UpdatePageElementTransformRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a UpdatePageElementTransformRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER ApplyMode
    Accepts the following type: string

    .PARAMETER ObjectId
    Accepts the following type: string

    .PARAMETER Transform
    Accepts the following type: Google.Apis.Slides.v1.Data.AffineTransform

    .EXAMPLE
    Add-GSSlideUpdatePageElementTransformRequest -ApplyMode $applyMode -ObjectId $objectId -Transform $transform
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $ApplyMode,
        [parameter()]
        [string]
        $ObjectId,
        [parameter()]
        [Google.Apis.Slides.v1.Data.AffineTransform]
        $Transform,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding UpdatePageElementTransformRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.UpdatePageElementTransformRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
            UpdatePageElementTransform = $newRequest
        }
    }
}
