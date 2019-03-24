function Add-GSSlideInsertTextRequest {
    <#
    .SYNOPSIS
    Creates a InsertTextRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a InsertTextRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER CellLocation
    Accepts the following type: Google.Apis.Slides.v1.Data.TableCellLocation

    .PARAMETER InsertionIndex
    Accepts the following type: System.Nullable[int]

    .PARAMETER ObjectId
    Accepts the following type: string

    .PARAMETER Text
    Accepts the following type: string

    .EXAMPLE
    Add-GSSlideInsertTextRequest -CellLocation $cellLocation -InsertionIndex $insertionIndex -ObjectId $objectId -Text $text
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Slides.v1.Data.TableCellLocation]
        $CellLocation,
        [parameter()]
        [System.Nullable[int]]
        $InsertionIndex,
        [parameter()]
        [string]
        $ObjectId,
        [parameter()]
        [string]
        $Text,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding InsertTextRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.InsertTextRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
            InsertTex = $newRequest
        }
    }
}
