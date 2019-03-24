function Add-GSSlideDuplicateObjectRequest {
    <#
    .SYNOPSIS
    Creates a DuplicateObjectRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a DuplicateObjectRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER ObjectId
    Accepts the following type: string

    .PARAMETER ObjectIds
    Accepts the following type: System.Collections.Generic.IDictionary[string,string]

    .EXAMPLE
    Add-GSSlideDuplicateObjectRequest -ObjectId $objectId -ObjectIds $objectIds
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $ObjectId,
        [parameter()]
        [System.Collections.Generic.IDictionary[string,string]]
        $ObjectIds,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding DuplicateObjectRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.DuplicateObjectRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
            DuplicateObjec = $newRequest
        }
    }
}
