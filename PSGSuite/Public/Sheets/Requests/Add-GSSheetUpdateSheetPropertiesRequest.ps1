function Add-GSSheetUpdateSheetPropertiesRequest {
    <#
    .SYNOPSIS
    Creates a UpdateSheetPropertiesRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a UpdateSheetPropertiesRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Fields
    Accepts the following type: System.Object

    .PARAMETER Properties
    Accepts the following type: Google.Apis.Sheets.v4.Data.SheetProperties

    .EXAMPLE
    Add-GSSheetUpdateSheetPropertiesRequest -Fields $fields -Properties $properties
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Object]
        $Fields,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.SheetProperties]
        $Properties,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding UpdateSheetPropertiesRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.UpdateSheetPropertiesRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
            UpdateSheetProperti = $newRequest
        }
    }
}
