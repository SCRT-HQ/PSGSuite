function Add-GSSlideUpdatePageElementsZOrderRequest {
    <#
    .SYNOPSIS
    Creates a UpdatePageElementsZOrderRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a UpdatePageElementsZOrderRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER Operation
    Accepts the following type: string.

    .PARAMETER PageElementObjectIds
    Accepts the following type: System.Collections.Generic.IList[string].

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSlideUpdatePageElementsZOrderRequest -Operation $operation -PageElementObjectIds $pageElementObjectIds
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $Operation,
        [parameter()]
        [System.Collections.Generic.IList[string]]
        $PageElementObjectIds,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding UpdatePageElementsZOrderRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.UpdatePageElementsZOrderRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
                UpdatePageElementsZOrder = $newRequest
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
