function Add-GSSheetDeleteEmbeddedObjectRequest {
    <#
    .SYNOPSIS
    Creates a DeleteEmbeddedObjectRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a DeleteEmbeddedObjectRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER ObjectId
    Accepts the following type: System.Nullable[int]

    .EXAMPLE
    Add-GSSheetDeleteEmbeddedObjectRequest -ObjectId $objectId
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Nullable[int]]
        $ObjectId,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding DeleteEmbeddedObjectRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.DeleteEmbeddedObjectRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
            DeleteEmbeddedObjec = $newRequest
        }
    }
}
