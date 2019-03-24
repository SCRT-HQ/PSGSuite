function Add-GSDocDeleteTableColumnRequest {
    <#
    .SYNOPSIS
    Creates a DeleteTableColumnRequest to pass to Submit-GSDocBatchUpdate.

    .DESCRIPTION
    Creates a DeleteTableColumnRequest to pass to Submit-GSDocBatchUpdate.

    .PARAMETER TableCellLocation
    Accepts the following type: Google.Apis.Docs.v1.Data.TableCellLocation

    .EXAMPLE
    Add-GSDocDeleteTableColumnRequest -TableCellLocation $tableCellLocation
    #>
    [OutputType('Google.Apis.Docs.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Docs.v1.Data.TableCellLocation]
        $TableCellLocation,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Docs.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding DeleteTableColumnRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Docs.v1.Data.DeleteTableColumnRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Docs.v1.Data.Request' -Property @{
            DeleteTableColumn = $newRequest
        }
    }
}
