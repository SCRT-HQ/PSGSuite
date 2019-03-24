function Add-GSSheetManualRule {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.ManualRule object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.ManualRule object.

    .PARAMETER Groups
    Accepts the following type: [Google.Apis.Sheets.v4.Data.ManualRuleGroup[]].

    To create this type, use the function Add-GSSheetManualRuleGroup or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.ManualRuleGroup'.

    .EXAMPLE
    Add-GSSheetManualRule -Groups $groups
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.ManualRule')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ManualRuleGroup[]]
        $Groups,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.ManualRule[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.ManualRule'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        switch ($prop) {
                            Groups {
                                $list = New-Object 'System.Collections.Generic.List[Google.Apis.Sheets.v4.Data.ManualRuleGroup]'
                                foreach ($item in $Groups) {
                                    $list.Add($item)
                                }
                                $obj.Groups = $list
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.ManualRule'
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
