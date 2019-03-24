function Add-GSSlideCreateLineRequest {
    <#
    .SYNOPSIS
    Creates a CreateLineRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a CreateLineRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER Category
    Accepts the following type: string.

    .PARAMETER ElementProperties
    Accepts the following type: Google.Apis.Slides.v1.Data.PageElementProperties.

    To create this type, use the function Add-GSSlidePageElementProperties or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.PageElementProperties'.

    .PARAMETER LineCategory
    Accepts the following type: string.

    .PARAMETER ObjectId
    Accepts the following type: string.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSlideCreateLineRequest -Category $category -ElementProperties $elementProperties -LineCategory $lineCategory -ObjectId $objectId
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $Category,
        [parameter()]
        [Google.Apis.Slides.v1.Data.PageElementProperties]
        $ElementProperties,
        [parameter()]
        [string]
        $LineCategory,
        [parameter()]
        [string]
        $ObjectId,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding CreateLineRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.CreateLineRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
                CreateLin = $newRequest
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
