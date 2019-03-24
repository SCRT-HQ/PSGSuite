function Add-GSSheetUpdateSpreadsheetPropertiesRequest {
    <#
    .SYNOPSIS
    Creates a UpdateSpreadsheetPropertiesRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a UpdateSpreadsheetPropertiesRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Fields
    Accepts the following type: System.Object.

    .PARAMETER Properties
    Accepts the following type: Google.Apis.Sheets.v4.Data.SpreadsheetProperties.

    To create this type, use the function Add-GSSheetSpreadsheetProperties or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.SpreadsheetProperties'.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSheetUpdateSpreadsheetPropertiesRequest -Fields $fields -Properties $properties
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Object]
        $Fields,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.SpreadsheetProperties]
        $Properties,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding UpdateSpreadsheetPropertiesRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.UpdateSpreadsheetPropertiesRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
                UpdateSpreadsheetProperti = $newRequest
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
