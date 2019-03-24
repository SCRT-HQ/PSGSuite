function Add-GSDocParagraphStyle {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Docs.v1.Data.ParagraphStyle object.

    .DESCRIPTION
    Creates a Google.Apis.Docs.v1.Data.ParagraphStyle object.

    .PARAMETER Alignment
    Accepts the following type: [string].

    .PARAMETER AvoidWidowAndOrphan
    Accepts the following type: [switch].

    .PARAMETER BorderBetween
    Accepts the following type: [Google.Apis.Docs.v1.Data.ParagraphBorder].

    To create this type, use the function Add-GSDocParagraphBorder or instantiate the type directly via New-Object 'Google.Apis.Docs.v1.Data.ParagraphBorder'.

    .PARAMETER BorderBottom
    Accepts the following type: [Google.Apis.Docs.v1.Data.ParagraphBorder].

    To create this type, use the function Add-GSDocParagraphBorder or instantiate the type directly via New-Object 'Google.Apis.Docs.v1.Data.ParagraphBorder'.

    .PARAMETER BorderLeft
    Accepts the following type: [Google.Apis.Docs.v1.Data.ParagraphBorder].

    To create this type, use the function Add-GSDocParagraphBorder or instantiate the type directly via New-Object 'Google.Apis.Docs.v1.Data.ParagraphBorder'.

    .PARAMETER BorderRight
    Accepts the following type: [Google.Apis.Docs.v1.Data.ParagraphBorder].

    To create this type, use the function Add-GSDocParagraphBorder or instantiate the type directly via New-Object 'Google.Apis.Docs.v1.Data.ParagraphBorder'.

    .PARAMETER BorderTop
    Accepts the following type: [Google.Apis.Docs.v1.Data.ParagraphBorder].

    To create this type, use the function Add-GSDocParagraphBorder or instantiate the type directly via New-Object 'Google.Apis.Docs.v1.Data.ParagraphBorder'.

    .PARAMETER Direction
    Accepts the following type: [string].

    .PARAMETER HeadingId
    Accepts the following type: [string].

    .PARAMETER IndentEnd
    Accepts the following type: [Google.Apis.Docs.v1.Data.Dimension].

    To create this type, use the function Add-GSDocDimension or instantiate the type directly via New-Object 'Google.Apis.Docs.v1.Data.Dimension'.

    .PARAMETER IndentFirstLine
    Accepts the following type: [Google.Apis.Docs.v1.Data.Dimension].

    To create this type, use the function Add-GSDocDimension or instantiate the type directly via New-Object 'Google.Apis.Docs.v1.Data.Dimension'.

    .PARAMETER IndentStart
    Accepts the following type: [Google.Apis.Docs.v1.Data.Dimension].

    To create this type, use the function Add-GSDocDimension or instantiate the type directly via New-Object 'Google.Apis.Docs.v1.Data.Dimension'.

    .PARAMETER KeepLinesTogether
    Accepts the following type: [switch].

    .PARAMETER KeepWithNext
    Accepts the following type: [switch].

    .PARAMETER LineSpacing
    Accepts the following type: [float].

    .PARAMETER NamedStyleType
    Accepts the following type: [string].

    .PARAMETER Shading
    Accepts the following type: [Google.Apis.Docs.v1.Data.Shading].

    To create this type, use the function Add-GSDocShading or instantiate the type directly via New-Object 'Google.Apis.Docs.v1.Data.Shading'.

    .PARAMETER SpaceAbove
    Accepts the following type: [Google.Apis.Docs.v1.Data.Dimension].

    To create this type, use the function Add-GSDocDimension or instantiate the type directly via New-Object 'Google.Apis.Docs.v1.Data.Dimension'.

    .PARAMETER SpaceBelow
    Accepts the following type: [Google.Apis.Docs.v1.Data.Dimension].

    To create this type, use the function Add-GSDocDimension or instantiate the type directly via New-Object 'Google.Apis.Docs.v1.Data.Dimension'.

    .PARAMETER SpacingMode
    Accepts the following type: [string].

    .PARAMETER TabStops
    Accepts the following type: [Google.Apis.Docs.v1.Data.TabStop[]].

    To create this type, use the function Add-GSDocTabStop or instantiate the type directly via New-Object 'Google.Apis.Docs.v1.Data.TabStop'.

    .EXAMPLE
    Add-GSDocParagraphStyle -Alignment $alignment -AvoidWidowAndOrphan $avoidWidowAndOrphan -BorderBetween $borderBetween -BorderBottom $borderBottom -BorderLeft $borderLeft -BorderRight $borderRight -BorderTop $borderTop -Direction $direction -HeadingId $headingId -IndentEnd $indentEnd -IndentFirstLine $indentFirstLine -IndentStart $indentStart -KeepLinesTogether $keepLinesTogether -KeepWithNext $keepWithNext -LineSpacing $lineSpacing -NamedStyleType $namedStyleType -Shading $shading -SpaceAbove $spaceAbove -SpaceBelow $spaceBelow -SpacingMode $spacingMode -TabStops $tabStops
    #>
    [OutputType('Google.Apis.Docs.v1.Data.ParagraphStyle')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $Alignment,
        [parameter()]
        [switch]
        $AvoidWidowAndOrphan,
        [parameter()]
        [Google.Apis.Docs.v1.Data.ParagraphBorder]
        $BorderBetween,
        [parameter()]
        [Google.Apis.Docs.v1.Data.ParagraphBorder]
        $BorderBottom,
        [parameter()]
        [Google.Apis.Docs.v1.Data.ParagraphBorder]
        $BorderLeft,
        [parameter()]
        [Google.Apis.Docs.v1.Data.ParagraphBorder]
        $BorderRight,
        [parameter()]
        [Google.Apis.Docs.v1.Data.ParagraphBorder]
        $BorderTop,
        [parameter()]
        [string]
        $Direction,
        [parameter()]
        [string]
        $HeadingId,
        [parameter()]
        [Google.Apis.Docs.v1.Data.Dimension]
        $IndentEnd,
        [parameter()]
        [Google.Apis.Docs.v1.Data.Dimension]
        $IndentFirstLine,
        [parameter()]
        [Google.Apis.Docs.v1.Data.Dimension]
        $IndentStart,
        [parameter()]
        [switch]
        $KeepLinesTogether,
        [parameter()]
        [switch]
        $KeepWithNext,
        [parameter()]
        [float]
        $LineSpacing,
        [parameter()]
        [string]
        $NamedStyleType,
        [parameter()]
        [Google.Apis.Docs.v1.Data.Shading]
        $Shading,
        [parameter()]
        [Google.Apis.Docs.v1.Data.Dimension]
        $SpaceAbove,
        [parameter()]
        [Google.Apis.Docs.v1.Data.Dimension]
        $SpaceBelow,
        [parameter()]
        [string]
        $SpacingMode,
        [parameter()]
        [Google.Apis.Docs.v1.Data.TabStop[]]
        $TabStops,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Docs.v1.Data.ParagraphStyle[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Docs.v1.Data.ParagraphStyle'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        switch ($prop) {
                            TabStops {
                                $list = New-Object 'System.Collections.Generic.List[Google.Apis.Docs.v1.Data.TabStop]'
                                foreach ($item in $TabStops) {
                                    $list.Add($item)
                                }
                                $obj.TabStops = $list
                            }
                            default {
                                $obj.$prop = $PSBoundParameters[$prop]
                            }
                        }
                    }
                    $obj
                }
                InputObject {
                    foreach ($iObj in $InputObject) {
                        $obj = New-Object 'Google.Apis.Docs.v1.Data.ParagraphStyle'
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
