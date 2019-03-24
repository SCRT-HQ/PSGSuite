function Add-GSSlideRange {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Slides.v1.Data.Range object.

    .DESCRIPTION
    Creates a Google.Apis.Slides.v1.Data.Range object.

    .PARAMETER EndIndex
    Accepts the following type: int

    .PARAMETER StartIndex
    Accepts the following type: int

    .PARAMETER Type
    Accepts the following type: string

    .EXAMPLE
    Add-GSSlideRange -EndIndex $endIndex -StartIndex $startIndex -Type $type
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Range')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [int]
        $EndIndex,
        [parameter()]
        [int]
        $StartIndex,
        [parameter()]
        [string]
        $Type,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Slides.v1.Data.Range[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Slides.v1.Data.Range'
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
                        $obj = New-Object 'Google.Apis.Slides.v1.Data.Range'
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
