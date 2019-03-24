function Add-GSSlideUpdatePageElementAltTextRequest {
    <#
    .SYNOPSIS
    Creates a UpdatePageElementAltTextRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a UpdatePageElementAltTextRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER Description
    Accepts the following type: string.

    .PARAMETER ObjectId
    Accepts the following type: string.

    .PARAMETER Title
    Accepts the following type: string.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSlideUpdatePageElementAltTextRequest -Description $description -ObjectId $objectId -Title $title
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $Description,
        [parameter()]
        [string]
        $ObjectId,
        [parameter()]
        [string]
        $Title,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding UpdatePageElementAltTextRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.UpdatePageElementAltTextRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
                UpdatePageElementAltTex = $newRequest
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
