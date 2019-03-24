function Add-GSSlideCreateVideoRequest {
    <#
    .SYNOPSIS
    Creates a CreateVideoRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a CreateVideoRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER ElementProperties
    Accepts the following type: [Google.Apis.Slides.v1.Data.PageElementProperties].

    To create this type, use the function Add-GSSlidePageElementProperties or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.PageElementProperties'.

    .PARAMETER Id
    Accepts the following type: [string].

    .PARAMETER ObjectId
    Accepts the following type: [string].

    .PARAMETER Source
    Accepts the following type: [string].

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSlideCreateVideoRequest -ElementProperties $elementProperties -Id $id -ObjectId $objectId -Source $source
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Slides.v1.Data.PageElementProperties]
        $ElementProperties,
        [parameter()]
        [string]
        $Id,
        [parameter()]
        [string]
        $ObjectId,
        [parameter()]
        [string]
        $Source,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding CreateVideoRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.CreateVideoRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
                CreateVideo = $newRequest
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
