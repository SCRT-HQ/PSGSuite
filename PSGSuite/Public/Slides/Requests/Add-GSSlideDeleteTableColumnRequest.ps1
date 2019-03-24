function Add-GSSlideDeleteTableColumnRequest {
    <#
    .SYNOPSIS
    Creates a DeleteTableColumnRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a DeleteTableColumnRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER CellLocation
    Accepts the following type: Google.Apis.Slides.v1.Data.TableCellLocation

    .PARAMETER TableObjectId
    Accepts the following type: string

    .EXAMPLE
    Add-GSSlideDeleteTableColumnRequest -CellLocation $cellLocation -TableObjectId $tableObjectId
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Slides.v1.Data.TableCellLocation]
        $CellLocation,
        [parameter()]
        [string]
        $TableObjectId,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding DeleteTableColumnRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.DeleteTableColumnRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
            DeleteTableColumn = $newRequest
        }
    }
}
