function Add-GSSlideMergeTableCellsRequest {
    <#
    .SYNOPSIS
    Creates a MergeTableCellsRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a MergeTableCellsRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER ObjectId
    Accepts the following type: string

    .PARAMETER TableRange
    Accepts the following type: Google.Apis.Slides.v1.Data.TableRange

    .EXAMPLE
    Add-GSSlideMergeTableCellsRequest -ObjectId $objectId -TableRange $tableRange
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $ObjectId,
        [parameter()]
        [Google.Apis.Slides.v1.Data.TableRange]
        $TableRange,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding MergeTableCellsRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.MergeTableCellsRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
            MergeTableCell = $newRequest
        }
    }
}
