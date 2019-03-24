function Add-GSDocParagraphBorder {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Docs.v1.Data.ParagraphBorder object.

    .DESCRIPTION
    Creates a Google.Apis.Docs.v1.Data.ParagraphBorder object.

    .PARAMETER Color
    Accepts the following type: [Google.Apis.Docs.v1.Data.OptionalColor].

    To create this type, use the function Add-GSDocOptionalColor or instantiate the type directly via New-Object 'Google.Apis.Docs.v1.Data.OptionalColor'.

    .PARAMETER DashStyle
    Accepts the following type: [string].

    .PARAMETER Padding
    Accepts the following type: [Google.Apis.Docs.v1.Data.Dimension].

    To create this type, use the function Add-GSDocDimension or instantiate the type directly via New-Object 'Google.Apis.Docs.v1.Data.Dimension'.

    .PARAMETER Width
    Accepts the following type: [Google.Apis.Docs.v1.Data.Dimension].

    To create this type, use the function Add-GSDocDimension or instantiate the type directly via New-Object 'Google.Apis.Docs.v1.Data.Dimension'.

    .EXAMPLE
    Add-GSDocParagraphBorder -Color $color -DashStyle $dashStyle -Padding $padding -Width $width
    #>
    [OutputType('Google.Apis.Docs.v1.Data.ParagraphBorder')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Docs.v1.Data.OptionalColor]
        $Color,
        [parameter()]
        [string]
        $DashStyle,
        [parameter()]
        [Google.Apis.Docs.v1.Data.Dimension]
        $Padding,
        [parameter()]
        [Google.Apis.Docs.v1.Data.Dimension]
        $Width,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Docs.v1.Data.ParagraphBorder[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Docs.v1.Data.ParagraphBorder'
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
                        $obj = New-Object 'Google.Apis.Docs.v1.Data.ParagraphBorder'
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
