function Add-GSSlideUpdateSlidesPositionRequest {
    <#
    .SYNOPSIS
    Creates a UpdateSlidesPositionRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a UpdateSlidesPositionRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER InsertionIndex
    Accepts the following type: [System.Nullable[int]].

    .PARAMETER SlideObjectIds
    Accepts the following type: [System.Collections.Generic.IList[string]].

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSlideUpdateSlidesPositionRequest -InsertionIndex $insertionIndex -SlideObjectIds $slideObjectIds
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Nullable[int]]
        $InsertionIndex,
        [parameter()]
        [System.Collections.Generic.IList[string]]
        $SlideObjectIds,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding UpdateSlidesPositionRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.UpdateSlidesPositionRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
                UpdateSlidesPosition = $newRequest
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
