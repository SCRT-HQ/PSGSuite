function Add-GSSlideLayoutReference {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.LayoutReference object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.LayoutReference object.

    .PARAMETER LayoutId
    Accepts the following type: string

    .PARAMETER PredefinedLayout
    Accepts the following type: string

    .EXAMPLE
    Add-GSSlideLayoutReference -LayoutId $layoutId -PredefinedLayout $predefinedLayout
    #>
    [OutputType('Google.Apis.Slides.v1.Data.LayoutReference')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $LayoutId,
        [parameter()]
        [string]
        $PredefinedLayout,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.LayoutReference[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.LayoutReference'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.LayoutReference'
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
