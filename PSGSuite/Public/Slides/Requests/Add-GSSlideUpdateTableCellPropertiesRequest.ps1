function Add-GSSlideUpdateTableCellPropertiesRequest {
    <#
    .SYNOPSIS
    Creates a UpdateTableCellPropertiesRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a UpdateTableCellPropertiesRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER Fields
    Accepts the following type: System.Object

    .PARAMETER ObjectId
    Accepts the following type: string

    .PARAMETER TableCellProperties
    Accepts the following type: Google.Apis.Slides.v1.Data.TableCellProperties

    .PARAMETER TableRange
    Accepts the following type: Google.Apis.Slides.v1.Data.TableRange

    .EXAMPLE
    Add-GSSlideUpdateTableCellPropertiesRequest -Fields $fields -ObjectId $objectId -TableCellProperties $tableCellProperties -TableRange $tableRange
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Object]
        $Fields,
        [parameter()]
        [string]
        $ObjectId,
        [parameter()]
        [Google.Apis.Slides.v1.Data.TableCellProperties]
        $TableCellProperties,
        [parameter()]
        [Google.Apis.Slides.v1.Data.TableRange]
        $TableRange,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding UpdateTableCellPropertiesRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.UpdateTableCellPropertiesRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
            UpdateTableCellProperti = $newRequest
        }
    }
}
