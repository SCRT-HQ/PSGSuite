function Add-GSSheetEditors {
    <#
    .SYNOPSIS
    Creates a Google.Apis.Sheets.v4.Data.Editors object.

    .DESCRIPTION
    Creates a Google.Apis.Sheets.v4.Data.Editors object.

    .PARAMETER DomainUsersCanEdit
    Accepts the following type: [switch].

    .PARAMETER Groups
    Accepts the following type: [string[]].

    .PARAMETER Users
    Accepts the following type: [string[]].

    .EXAMPLE
    Add-GSSheetEditors -DomainUsersCanEdit $domainUsersCanEdit -Groups $groups -Users $users
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Editors')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [switch]
        $DomainUsersCanEdit,
        [parameter()]
        [string[]]
        $Groups,
        [parameter()]
        [string[]]
        $Users,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ParameterSetName = "InputObject")]
        [Google.Apis.Sheets.v4.Data.Editors[]]
        $InputObject
    )
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.Sheets.v4.Data.Editors'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        switch ($prop) {
                            Groups {
                                $list = New-Object 'System.Collections.Generic.List[string]'
                                foreach ($item in $Groups) {
                                    $list.Add($item)
                                }
                                $obj.Groups = $list
                            }
                            Users {
                                $list = New-Object 'System.Collections.Generic.List[string]'
                                foreach ($item in $Users) {
                                    $list.Add($item)
                                }
                                $obj.Users = $list
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
                        $obj = New-Object 'Google.Apis.Sheets.v4.Data.Editors'
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
