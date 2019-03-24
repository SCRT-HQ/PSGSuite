function Add-GSSlideUpdateTableBorderPropertiesRequest {
    <#
    .SYNOPSIS
    Creates a UpdateTableBorderPropertiesRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a UpdateTableBorderPropertiesRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER BorderPosition
    Accepts the following type: string.

    .PARAMETER Fields
    Accepts the following type: System.Object.

    .PARAMETER ObjectId
    Accepts the following type: string.

    .PARAMETER TableBorderProperties
    Accepts the following type: Google.Apis.Slides.v1.Data.TableBorderProperties.

    To create this type, use the function Add-GSSlideTableBorderProperties or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.TableBorderProperties'.

    .PARAMETER TableRange
    Accepts the following type: Google.Apis.Slides.v1.Data.TableRange.

    To create this type, use the function Add-GSSlideTableRange or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.TableRange'.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSlideUpdateTableBorderPropertiesRequest -BorderPosition $borderPosition -Fields $fields -ObjectId $objectId -TableBorderProperties $tableBorderProperties -TableRange $tableRange
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $BorderPosition,
        [parameter()]
        [System.Object]
        $Fields,
        [parameter()]
        [string]
        $ObjectId,
        [parameter()]
        [Google.Apis.Slides.v1.Data.TableBorderProperties]
        $TableBorderProperties,
        [parameter()]
        [Google.Apis.Slides.v1.Data.TableRange]
        $TableRange,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding UpdateTableBorderPropertiesRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.UpdateTableBorderPropertiesRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
                UpdateTableBorderProperti = $newRequest
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
