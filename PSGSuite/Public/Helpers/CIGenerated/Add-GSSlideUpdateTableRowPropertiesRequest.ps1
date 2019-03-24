function Add-GSSlideUpdateTableRowPropertiesRequest {
    <#
    .SYNOPSIS
    Creates a UpdateTableRowPropertiesRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a UpdateTableRowPropertiesRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER Fields
    Accepts the following type: System.Object.

    .PARAMETER ObjectId
    Accepts the following type: string.

    .PARAMETER RowIndices
    Accepts the following type: System.Collections.Generic.IList[System.Nullable[int]].

    .PARAMETER TableRowProperties
    Accepts the following type: Google.Apis.Slides.v1.Data.TableRowProperties.

    To create this type, use the function Add-GSSlideTableRowProperties or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.TableRowProperties'.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSlideUpdateTableRowPropertiesRequest -Fields $fields -ObjectId $objectId -RowIndices $rowIndices -TableRowProperties $tableRowProperties
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
        [System.Collections.Generic.IList[System.Nullable[int]]]
        $RowIndices,
        [parameter()]
        [Google.Apis.Slides.v1.Data.TableRowProperties]
        $TableRowProperties,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding UpdateTableRowPropertiesRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.UpdateTableRowPropertiesRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
                UpdateTableRowProperti = $newRequest
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
