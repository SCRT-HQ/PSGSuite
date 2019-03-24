function Add-GSSheetProtectedRange {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.ProtectedRange object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.ProtectedRange object.

    .PARAMETER Description
    Accepts the following type: string

    .PARAMETER Editors
    Accepts the following type: Google.Apis.Sheets.v4.Data.Editors

    .PARAMETER NamedRangeId
    Accepts the following type: string

    .PARAMETER ProtectedRangeId
    Accepts the following type: int

    .PARAMETER Range
    Accepts the following type: Google.Apis.Sheets.v4.Data.GridRange

    .PARAMETER RequestingUserCanEdit
    Accepts the following type: bool

    .PARAMETER UnprotectedRanges
    Accepts the following type: System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.GridRange][]

    .PARAMETER WarningOnly
    Accepts the following type: bool

    .EXAMPLE
    Add-GSSheetProtectedRange -Description $description -Editors $editors -NamedRangeId $namedRangeId -ProtectedRangeId $protectedRangeId -Range $range -RequestingUserCanEdit $requestingUserCanEdit -UnprotectedRanges $unprotectedRanges -WarningOnly $warningOnly
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.ProtectedRange')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $Description,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.Editors]
        $Editors,
        [parameter()]
        [string]
        $NamedRangeId,
        [parameter()]
        [int]
        $ProtectedRangeId,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.GridRange]
        $Range,
        [parameter()]
        [bool]
        $RequestingUserCanEdit,
        [parameter()]
        [System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.GridRange][]]
        $UnprotectedRanges,
        [parameter()]
        [bool]
        $WarningOnly,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.ProtectedRange[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.ProtectedRange'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        switch ($prop) {
                            UnprotectedRanges {
                                $list = New-Object 'System.Collections.Generic.List[System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.GridRange]]'
                                foreach ($item in $UnprotectedRanges) {
                                    $list.Add($item)
                                }
                                $obj.UnprotectedRanges = $list
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.ProtectedRange'
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
