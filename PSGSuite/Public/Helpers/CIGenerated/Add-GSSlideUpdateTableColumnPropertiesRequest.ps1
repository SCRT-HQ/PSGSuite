function Add-GSSlideUpdateTableColumnPropertiesRequest {
    <#
    .SYNOPSIS
    Creates a UpdateTableColumnPropertiesRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a UpdateTableColumnPropertiesRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER ColumnIndices
    Accepts the following type: System.Collections.Generic.IList[System.Nullable[int]].

    .PARAMETER Fields
    Accepts the following type: System.Object.

    .PARAMETER ObjectId
    Accepts the following type: string.

    .PARAMETER TableColumnProperties
    Accepts the following type: Google.Apis.Slides.v1.Data.TableColumnProperties.

    To create this type, use the function Add-GSSlideTableColumnProperties or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.TableColumnProperties'.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSlideUpdateTableColumnPropertiesRequest -ColumnIndices $columnIndices -Fields $fields -ObjectId $objectId -TableColumnProperties $tableColumnProperties
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Collections.Generic.IList[System.Nullable[int]]]
        $ColumnIndices,
        [parameter()]
        [System.Object]
        $Fields,
        [parameter()]
        [string]
        $ObjectId,
        [parameter()]
        [Google.Apis.Slides.v1.Data.TableColumnProperties]
        $TableColumnProperties,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding UpdateTableColumnPropertiesRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.UpdateTableColumnPropertiesRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
                UpdateTableColumnProperti = $newRequest
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
