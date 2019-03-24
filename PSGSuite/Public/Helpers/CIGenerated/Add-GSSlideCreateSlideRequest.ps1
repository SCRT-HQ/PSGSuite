function Add-GSSlideCreateSlideRequest {
    <#
    .SYNOPSIS
    Creates a CreateSlideRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a CreateSlideRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER InsertionIndex
    Accepts the following type: System.Nullable[int].

    .PARAMETER ObjectId
    Accepts the following type: string.

    .PARAMETER PlaceholderIdMappings
    Accepts the following type: System.Collections.Generic.IList[Google.Apis.Slides.v1.Data.LayoutPlaceholderIdMapping].

    .PARAMETER SlideLayoutReference
    Accepts the following type: Google.Apis.Slides.v1.Data.LayoutReference.

    To create this type, use the function Add-GSSlideLayoutReference or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.LayoutReference'.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSlideCreateSlideRequest -InsertionIndex $insertionIndex -ObjectId $objectId -PlaceholderIdMappings $placeholderIdMappings -SlideLayoutReference $slideLayoutReference
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Nullable[int]]
        $InsertionIndex,
        [parameter()]
        [string]
        $ObjectId,
        [parameter()]
        [System.Collections.Generic.IList[Google.Apis.Slides.v1.Data.LayoutPlaceholderIdMapping]]
        $PlaceholderIdMappings,
        [parameter()]
        [Google.Apis.Slides.v1.Data.LayoutReference]
        $SlideLayoutReference,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding CreateSlideRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.CreateSlideRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
                CreateSlid = $newRequest
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
