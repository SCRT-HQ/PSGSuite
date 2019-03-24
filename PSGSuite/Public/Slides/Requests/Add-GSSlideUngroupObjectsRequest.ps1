function Add-GSSlideUngroupObjectsRequest {
    <#
    .SYNOPSIS
    Creates a UngroupObjectsRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a UngroupObjectsRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER ObjectIds
    Accepts the following type: System.Collections.Generic.IList[string]

    .EXAMPLE
    Add-GSSlideUngroupObjectsRequest -ObjectIds $objectIds
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Collections.Generic.IList[string]]
        $ObjectIds,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding UngroupObjectsRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.UngroupObjectsRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
            UngroupObjec = $newRequest
        }
    }
}
