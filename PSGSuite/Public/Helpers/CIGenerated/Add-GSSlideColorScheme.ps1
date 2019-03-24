function Add-GSSlideColorScheme {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.ColorScheme object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.ColorScheme object.

    .PARAMETER Colors
    Accepts the following type: [Google.Apis.Slides.v1.Data.ThemeColorPair[]].

    To create this type, use the function Add-GSSlideThemeColorPair or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.ThemeColorPair'.

    .EXAMPLE
    Add-GSSlideColorScheme -Colors $colors
    #>
    [OutputType('Google.Apis.Slides.v1.Data.ColorScheme')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Slides.v1.Data.ThemeColorPair[]]
        $Colors,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.ColorScheme[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.ColorScheme'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        switch ($prop) {
                            Colors {
                                $list = New-Object 'System.Collections.Generic.List[Google.Apis.Slides.v1.Data.ThemeColorPair]'
                                foreach ($item in $Colors) {
                                    $list.Add($item)
                                }
                                $obj.Colors = $list
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.ColorScheme'
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
