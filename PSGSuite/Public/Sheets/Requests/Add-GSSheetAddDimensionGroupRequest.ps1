function Add-GSSheetAddDimensionGroupRequest {
    <#
    .SYNOPSIS
    Creates a AddDimensionGroupRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a AddDimensionGroupRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Range
    Accepts the following type: Google.Apis.Sheets.v4.Data.DimensionRange

    .EXAMPLE
    Add-GSSheetAddDimensionGroupRequest -Range $range
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.DimensionRange]
        $Range,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding AddDimensionGroupRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.AddDimensionGroupRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
            AddDimensionGroup = $newRequest
        }
    }
}
