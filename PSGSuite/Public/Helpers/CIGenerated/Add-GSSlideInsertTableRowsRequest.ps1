function Add-GSSlideInsertTableRowsRequest {
    <#
    .SYNOPSIS
    Creates a InsertTableRowsRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a InsertTableRowsRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER CellLocation
    Accepts the following type: [Google.Apis.Slides.v1.Data.TableCellLocation].

    To create this type, use the function Add-GSSlideTableCellLocation or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.TableCellLocation'.

    .PARAMETER InsertBelow
    Accepts the following type: [System.Nullable[bool]].

    .PARAMETER Number
    Accepts the following type: [System.Nullable[int]].

    .PARAMETER TableObjectId
    Accepts the following type: [string].

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSlideInsertTableRowsRequest -CellLocation $cellLocation -InsertBelow $insertBelow -Number $number -TableObjectId $tableObjectId
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Slides.v1.Data.TableCellLocation]
        $CellLocation,
        [parameter()]
        [System.Nullable[bool]]
        $InsertBelow,
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
        Write-Verbose "Adding InsertTableRowsRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.InsertTableRowsRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
                InsertTableRow = $newRequest
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
