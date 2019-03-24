function Add-GSSlideUpdateTextStyleRequest {
    <#
    .SYNOPSIS
    Creates a UpdateTextStyleRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a UpdateTextStyleRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER CellLocation
    Accepts the following type: Google.Apis.Slides.v1.Data.TableCellLocation.

    To create this type, use the function Add-GSSlideTableCellLocation or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.TableCellLocation'.

    .PARAMETER Fields
    Accepts the following type: System.Object.

    .PARAMETER ObjectId
    Accepts the following type: string.

    .PARAMETER Style
    Accepts the following type: Google.Apis.Slides.v1.Data.TextStyle.

    To create this type, use the function Add-GSSlideTextStyle or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.TextStyle'.

    .PARAMETER TextRange
    Accepts the following type: Google.Apis.Slides.v1.Data.Range.

    To create this type, use the function Add-GSSlideRange or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.Range'.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSlideUpdateTextStyleRequest -CellLocation $cellLocation -Fields $fields -ObjectId $objectId -Style $style -TextRange $textRange
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Slides.v1.Data.TableCellLocation]
        $CellLocation,
        [parameter()]
        [System.Object]
        $Fields,
        [parameter()]
        [string]
        $ObjectId,
        [parameter()]
        [Google.Apis.Slides.v1.Data.TextStyle]
        $Style,
        [parameter()]
        [Google.Apis.Slides.v1.Data.Range]
        $TextRange,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding UpdateTextStyleRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.UpdateTextStyleRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
                UpdateTextStyl = $newRequest
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
