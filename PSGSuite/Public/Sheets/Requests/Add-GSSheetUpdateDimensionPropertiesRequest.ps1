function Add-GSSheetUpdateDimensionPropertiesRequest {
    <#
    .SYNOPSIS
    Creates a UpdateDimensionPropertiesRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a UpdateDimensionPropertiesRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Fields
    Accepts the following type: System.Object

    .PARAMETER Properties
    Accepts the following type: Google.Apis.Sheets.v4.Data.DimensionProperties

    .PARAMETER Range
    Accepts the following type: Google.Apis.Sheets.v4.Data.DimensionRange

    .EXAMPLE
    Add-GSSheetUpdateDimensionPropertiesRequest -Fields $fields -Properties $properties -Range $range
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Object]
        $Fields,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.DimensionProperties]
        $Properties,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.DimensionRange]
        $Range,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding UpdateDimensionPropertiesRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.UpdateDimensionPropertiesRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
            UpdateDimensionProperti = $newRequest
        }
    }
}
