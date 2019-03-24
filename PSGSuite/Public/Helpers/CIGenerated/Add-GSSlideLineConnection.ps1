function Add-GSSlideLineConnection {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.LineConnection object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.LineConnection object.

    .PARAMETER ConnectedObjectId
    Accepts the following type: string

    .PARAMETER ConnectionSiteIndex
    Accepts the following type: int

    .EXAMPLE
    Add-GSSlideLineConnection -ConnectedObjectId $connectedObjectId -ConnectionSiteIndex $connectionSiteIndex
    #>
    [OutputType('Google.Apis.Slides.v1.Data.LineConnection')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $ConnectedObjectId,
        [parameter()]
        [int]
        $ConnectionSiteIndex,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.LineConnection[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.LineConnection'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.LineConnection'
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
