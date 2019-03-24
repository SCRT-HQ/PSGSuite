function Add-GSDocEndOfSegmentLocation {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Docs.v1.Data.EndOfSegmentLocation object.

    .DESCRIPTION
    Creates a Google.Apis.Docs.v1.Data.EndOfSegmentLocation object.

    .PARAMETER SegmentId
    Accepts the following type: [string].

    .EXAMPLE
    Add-GSDocEndOfSegmentLocation -SegmentId $segmentId
    #>
    [OutputType('Google.Apis.Docs.v1.Data.EndOfSegmentLocation')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $SegmentId,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Docs.v1.Data.EndOfSegmentLocation[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Docs.v1.Data.EndOfSegmentLocation'
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
                        $obj = New-Object 'Google.Apis.Docs.v1.Data.EndOfSegmentLocation'
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
