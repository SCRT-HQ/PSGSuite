function Add-GSSlideReplaceAllShapesWithImageRequest {
    <#
    .SYNOPSIS
    Creates a ReplaceAllShapesWithImageRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a ReplaceAllShapesWithImageRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER ContainsText
    Accepts the following type: Google.Apis.Slides.v1.Data.SubstringMatchCriteria

    .PARAMETER ImageReplaceMethod
    Accepts the following type: string

    .PARAMETER ImageUrl
    Accepts the following type: string

    .PARAMETER PageObjectIds
    Accepts the following type: System.Collections.Generic.IList[string]

    .PARAMETER ReplaceMethod
    Accepts the following type: string

    .EXAMPLE
    Add-GSSlideReplaceAllShapesWithImageRequest -ContainsText $containsText -ImageReplaceMethod $imageReplaceMethod -ImageUrl $imageUrl -PageObjectIds $pageObjectIds -ReplaceMethod $replaceMethod
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Slides.v1.Data.SubstringMatchCriteria]
        $ContainsText,
        [parameter()]
        [string]
        $ImageReplaceMethod,
        [parameter()]
        [string]
        $ImageUrl,
        [parameter()]
        [System.Collections.Generic.IList[string]]
        $PageObjectIds,
        [parameter()]
        [string]
        $ReplaceMethod,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding ReplaceAllShapesWithImageRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.ReplaceAllShapesWithImageRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
            ReplaceAllShapesWithImag = $newRequest
        }
    }
}
