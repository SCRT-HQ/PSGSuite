function Add-GSSlideGroupObjectsRequest {
    <#
    .SYNOPSIS
    Creates a GroupObjectsRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a GroupObjectsRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER ChildrenObjectIds
    Accepts the following type: System.Collections.Generic.IList[string]

    .PARAMETER GroupObjectId
    Accepts the following type: string

    .EXAMPLE
    Add-GSSlideGroupObjectsRequest -ChildrenObjectIds $childrenObjectIds -GroupObjectId $groupObjectId
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Collections.Generic.IList[string]]
        $ChildrenObjectIds,
        [parameter()]
        [string]
        $GroupObjectId,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding GroupObjectsRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.GroupObjectsRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
            GroupObjec = $newRequest
        }
    }
}
