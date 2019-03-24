function Add-GSSlideInsertTableColumnsRequest {
    <#
    .SYNOPSIS
    Creates a InsertTableColumnsRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a InsertTableColumnsRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER CellLocation
    Accepts the following type: Google.Apis.Slides.v1.Data.TableCellLocation

    .PARAMETER InsertRight
    Accepts the following type: System.Nullable[bool]

    .PARAMETER Number
    Accepts the following type: System.Nullable[int]

    .PARAMETER TableObjectId
    Accepts the following type: string

    .EXAMPLE
    Add-GSSlideInsertTableColumnsRequest -CellLocation $cellLocation -InsertRight $insertRight -Number $number -TableObjectId $tableObjectId
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Slides.v1.Data.TableCellLocation]
        $CellLocation,
        [parameter()]
        [System.Nullable[bool]]
        $InsertRight,
        [parameter()]
        [System.Nullable[int]]
        $Number,
        [parameter()]
        [string]
        $TableObjectId,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding InsertTableColumnsRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.InsertTableColumnsRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
            InsertTableColumn = $newRequest
        }
    }
}
