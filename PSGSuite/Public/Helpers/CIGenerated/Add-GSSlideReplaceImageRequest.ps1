function Add-GSSlideReplaceImageRequest {
    <#
    .SYNOPSIS
    Creates a ReplaceImageRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a ReplaceImageRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER ImageObjectId
    Accepts the following type: string.

    .PARAMETER ImageReplaceMethod
    Accepts the following type: string.

    .PARAMETER Url
    Accepts the following type: string.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSlideReplaceImageRequest -ImageObjectId $imageObjectId -ImageReplaceMethod $imageReplaceMethod -Url $url
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $ImageObjectId,
        [parameter()]
        [string]
        $ImageReplaceMethod,
        [parameter()]
        [string]
        $Url,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding ReplaceImageRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.ReplaceImageRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
                ReplaceImag = $newRequest
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
