function Add-GSDocLink {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Docs.v1.Data.Link object.

    .DESCRIPTION
    Creates a Google.Apis.Docs.v1.Data.Link object.

    .PARAMETER BookmarkId
    Accepts the following type: [string].

    .PARAMETER HeadingId
    Accepts the following type: [string].

    .PARAMETER Url
    Accepts the following type: [string].

    .EXAMPLE
    Add-GSDocLink -BookmarkId $bookmarkId -HeadingId $headingId -Url $url
    #>
    [OutputType('Google.Apis.Docs.v1.Data.Link')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $BookmarkId,
        [parameter()]
        [string]
        $HeadingId,
        [parameter()]
        [string]
        $Url,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Docs.v1.Data.Link[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Docs.v1.Data.Link'
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
                        $obj = New-Object 'Google.Apis.Docs.v1.Data.Link'
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
