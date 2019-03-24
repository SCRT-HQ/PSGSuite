function Add-GSSlideCreateImageRequest {
    <#
    .SYNOPSIS
    Creates a CreateImageRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a CreateImageRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER ElementProperties
    Accepts the following type: [Google.Apis.Slides.v1.Data.PageElementProperties].

    To create this type, use the function Add-GSSlidePageElementProperties or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.PageElementProperties'.

    .PARAMETER ObjectId
    Accepts the following type: [string].

    .PARAMETER Url
    Accepts the following type: [string].

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSlideCreateImageRequest -ElementProperties $elementProperties -ObjectId $objectId -Url $url
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
        $Url,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding CreateImageRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.CreateImageRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
                CreateImag = $newRequest
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
