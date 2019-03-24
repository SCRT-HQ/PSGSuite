function Add-GSSheetInsertDimensionRequest {
    <#
    .SYNOPSIS
    Creates a InsertDimensionRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a InsertDimensionRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER InheritFromBefore
    Accepts the following type: System.Nullable[bool]

    .PARAMETER Range
    Accepts the following type: Google.Apis.Sheets.v4.Data.DimensionRange

    .EXAMPLE
    Add-GSSheetInsertDimensionRequest -InheritFromBefore $inheritFromBefore -Range $range
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Nullable[bool]]
        $InheritFromBefore,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.DimensionRange]
        $Range,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding InsertDimensionRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.InsertDimensionRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
            InsertDimension = $newRequest
        }
    }
}
