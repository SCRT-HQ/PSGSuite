function Add-GSDocRange {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Docs.v1.Data.Range object.

    .DESCRIPTION
    Creates a Google.Apis.Docs.v1.Data.Range object.

    .PARAMETER EndIndex
    Accepts the following type: int

    .PARAMETER SegmentId
    Accepts the following type: string

    .PARAMETER StartIndex
    Accepts the following type: int

    .EXAMPLE
    Add-GSDocRange -EndIndex $endIndex -SegmentId $segmentId -StartIndex $startIndex
    #>
    [OutputType('Google.Apis.Docs.v1.Data.Range')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [int]
        $EndIndex,
        [parameter()]
        [string]
        $SegmentId,
        [parameter()]
        [int]
        $StartIndex,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Docs.v1.Data.Range[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Docs.v1.Data.Range'
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
                        $obj = New-Object 'Google.Apis.Docs.v1.Data.Range'
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
