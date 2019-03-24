function Add-GSSheetManualRuleGroup {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.ManualRuleGroup object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.ManualRuleGroup object.

    .PARAMETER GroupName
    Accepts the following type: [Google.Apis.Sheets.v4.Data.ExtendedValue].

    To create this type, use the function Add-GSSheetExtendedValue or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.ExtendedValue'.

    .PARAMETER Items
    Accepts the following type: [Google.Apis.Sheets.v4.Data.ExtendedValue[]].

    To create this type, use the function Add-GSSheetExtendedValue or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.ExtendedValue'.

    .EXAMPLE
    Add-GSSheetManualRuleGroup -GroupName $groupName -Items $items
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.ManualRuleGroup')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ExtendedValue]
        $GroupName,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.ExtendedValue[]]
        $Items,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.ManualRuleGroup[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.ManualRuleGroup'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        switch ($prop) {
                            Items {
                                $list = New-Object 'System.Collections.Generic.List[Google.Apis.Sheets.v4.Data.ExtendedValue]'
                                foreach ($item in $Items) {
                                    $list.Add($item)
                                }
                                $obj.Items = $list
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.ManualRuleGroup'
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
