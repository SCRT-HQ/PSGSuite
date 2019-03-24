function Add-GSDocInsertInlineImageRequest {
    <#
    .SYNOPSIS
    Creates a InsertInlineImageRequest to pass to Submit-GSDocBatchUpdate.

    .DESCRIPTION
    Creates a InsertInlineImageRequest to pass to Submit-GSDocBatchUpdate.

    .PARAMETER EndOfSegmentLocation
    Accepts the following type: Google.Apis.Docs.v1.Data.EndOfSegmentLocation

    .PARAMETER Location
    Accepts the following type: Google.Apis.Docs.v1.Data.Location

    .PARAMETER ObjectSize
    Accepts the following type: Google.Apis.Docs.v1.Data.Size

    .PARAMETER Uri
    Accepts the following type: string

    .EXAMPLE
    Add-GSDocInsertInlineImageRequest -EndOfSegmentLocation $endOfSegmentLocation -Location $location -ObjectSize $objectSize -Uri $uri
    #>
    [OutputType('Google.Apis.Docs.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Docs.v1.Data.EndOfSegmentLocation]
        $EndOfSegmentLocation,
        [parameter()]
        [Google.Apis.Docs.v1.Data.Location]
        $Location,
        [parameter()]
        [Google.Apis.Docs.v1.Data.Size]
        $ObjectSize,
        [parameter()]
        [string]
        $Uri,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Docs.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding InsertInlineImageRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Docs.v1.Data.InsertInlineImageRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Docs.v1.Data.Request' -Property @{
            InsertInlineImag = $newRequest
        }
    }
}
