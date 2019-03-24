function Add-GSSlideUpdateLinePropertiesRequest {
    <#
    .SYNOPSIS
    Creates a UpdateLinePropertiesRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a UpdateLinePropertiesRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER Fields
    Accepts the following type: [System.Object].

    .PARAMETER LineProperties
    Accepts the following type: [Google.Apis.Slides.v1.Data.LineProperties].

    To create this type, use the function Add-GSSlideLineProperties or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.LineProperties'.

    .PARAMETER ObjectId
    Accepts the following type: [string].

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSlideUpdateLinePropertiesRequest -Fields $fields -LineProperties $lineProperties -ObjectId $objectId
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Object]
        $Fields,
        [parameter()]
        [Google.Apis.Slides.v1.Data.LineProperties]
        $LineProperties,
        [parameter()]
        [string]
        $ObjectId,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding UpdateLinePropertiesRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.UpdateLinePropertiesRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
                UpdateLineProperti = $newRequest
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
