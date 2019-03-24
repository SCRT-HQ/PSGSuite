function Add-GSSlidePageProperties {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.PageProperties object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.PageProperties object.

    .PARAMETER ColorScheme
    Accepts the following type: Google.Apis.Slides.v1.Data.ColorScheme

    .PARAMETER PageBackgroundFill
    Accepts the following type: Google.Apis.Slides.v1.Data.PageBackgroundFill

    .EXAMPLE
    Add-GSSlidePageProperties -ColorScheme $colorScheme -PageBackgroundFill $pageBackgroundFill
    #>
    [OutputType('Google.Apis.Slides.v1.Data.PageProperties')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Slides.v1.Data.ColorScheme]
        $ColorScheme,
        [parameter()]
        [Google.Apis.Slides.v1.Data.PageBackgroundFill]
        $PageBackgroundFill,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.PageProperties[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.PageProperties'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.PageProperties'
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
