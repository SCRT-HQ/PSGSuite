function Add-GSSlideLink {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.Link object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.Link object.

    .PARAMETER PageObjectId
    Accepts the following type: string

    .PARAMETER RelativeLink
    Accepts the following type: string

    .PARAMETER SlideIndex
    Accepts the following type: int

    .PARAMETER Url
    Accepts the following type: string

    .EXAMPLE
    Add-GSSlideLink -PageObjectId $pageObjectId -RelativeLink $relativeLink -SlideIndex $slideIndex -Url $url
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Link')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $PageObjectId,
        [parameter()]
        [string]
        $RelativeLink,
        [parameter()]
        [int]
        $SlideIndex,
        [parameter()]
        [string]
        $Url,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.Link[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.Link'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.Link'
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
