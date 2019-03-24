function Add-GSDocTabStop {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Docs.v1.Data.TabStop object.

    .DESCRIPTION
    Creates a Google.Apis.Docs.v1.Data.TabStop object.

    .PARAMETER Alignment
    Accepts the following type: [string].

    .PARAMETER Offset
    Accepts the following type: [Google.Apis.Docs.v1.Data.Dimension].

    To create this type, use the function Add-GSDocDimension or instantiate the type directly via New-Object 'Google.Apis.Docs.v1.Data.Dimension'.

    .EXAMPLE
    Add-GSDocTabStop -Alignment $alignment -Offset $offset
    #>
    [OutputType('Google.Apis.Docs.v1.Data.TabStop')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $Alignment,
        [parameter()]
        [Google.Apis.Docs.v1.Data.Dimension]
        $Offset,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Docs.v1.Data.TabStop[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Docs.v1.Data.TabStop'
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
                        $obj = New-Object 'Google.Apis.Docs.v1.Data.TabStop'
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
