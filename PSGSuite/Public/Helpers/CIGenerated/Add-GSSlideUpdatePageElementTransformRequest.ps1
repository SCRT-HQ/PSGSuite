function Add-GSSlideUpdatePageElementTransformRequest {
    <#
    .SYNOPSIS
    Creates a UpdatePageElementTransformRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a UpdatePageElementTransformRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER ApplyMode
    Accepts the following type: [string].

    .PARAMETER ObjectId
    Accepts the following type: [string].

    .PARAMETER Transform
    Accepts the following type: [Google.Apis.Slides.v1.Data.AffineTransform].

    To create this type, use the function Add-GSSlideAffineTransform or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.AffineTransform'.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

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
        try {
            New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
                UpdatePageElementTransform = $newRequest
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
