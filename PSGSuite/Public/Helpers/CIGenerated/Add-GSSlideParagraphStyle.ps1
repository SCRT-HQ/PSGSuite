function Add-GSSlideParagraphStyle {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.ParagraphStyle object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.ParagraphStyle object.

    .PARAMETER Alignment
    Accepts the following type: string

    .PARAMETER Direction
    Accepts the following type: string

    .PARAMETER IndentEnd
    Accepts the following type: Google.Apis.Slides.v1.Data.Dimension

    .PARAMETER IndentFirstLine
    Accepts the following type: Google.Apis.Slides.v1.Data.Dimension

    .PARAMETER IndentStart
    Accepts the following type: Google.Apis.Slides.v1.Data.Dimension

    .PARAMETER LineSpacing
    Accepts the following type: float

    .PARAMETER SpaceAbove
    Accepts the following type: Google.Apis.Slides.v1.Data.Dimension

    .PARAMETER SpaceBelow
    Accepts the following type: Google.Apis.Slides.v1.Data.Dimension

    .PARAMETER SpacingMode
    Accepts the following type: string

    .EXAMPLE
    Add-GSSlideParagraphStyle -Alignment $alignment -Direction $direction -IndentEnd $indentEnd -IndentFirstLine $indentFirstLine -IndentStart $indentStart -LineSpacing $lineSpacing -SpaceAbove $spaceAbove -SpaceBelow $spaceBelow -SpacingMode $spacingMode
    #>
    [OutputType('Google.Apis.Slides.v1.Data.ParagraphStyle')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $Alignment,
        [parameter()]
        [string]
        $Direction,
        [parameter()]
        [Google.Apis.Slides.v1.Data.Dimension]
        $IndentEnd,
        [parameter()]
        [Google.Apis.Slides.v1.Data.Dimension]
        $IndentFirstLine,
        [parameter()]
        [Google.Apis.Slides.v1.Data.Dimension]
        $IndentStart,
        [parameter()]
        [float]
        $LineSpacing,
        [parameter()]
        [Google.Apis.Slides.v1.Data.Dimension]
        $SpaceAbove,
        [parameter()]
        [Google.Apis.Slides.v1.Data.Dimension]
        $SpaceBelow,
        [parameter()]
        [string]
        $SpacingMode,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.ParagraphStyle[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.ParagraphStyle'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        switch ($prop) {
                            default {
                                $obj.$prop = $PSBoundParameters[$prop]
                            }
                        }
                    }
                    $obj
                }
                InputObject {
                    foreach ($iObj in $InputObject) {
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.ParagraphStyle'
                        foreach ($prop in $iObj.PSObject.Properties.Name | Where-Object {$obj.PSObject.Properties.Name -contains $_ -and $_ -ne 'ETag'}) {
                            $obj.$prop = $iObj.$prop
                        }
                        $obj
                    }
                }
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
