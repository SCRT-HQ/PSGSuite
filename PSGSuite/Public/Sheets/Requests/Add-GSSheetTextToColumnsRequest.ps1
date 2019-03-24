function Add-GSSheetTextToColumnsRequest {
    <#
    .SYNOPSIS
    Creates a TextToColumnsRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a TextToColumnsRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Delimiter
    Accepts the following type: string

    .PARAMETER DelimiterType
    Accepts the following type: string

    .PARAMETER Source
    Accepts the following type: Google.Apis.Sheets.v4.Data.GridRange

    .EXAMPLE
    Add-GSSheetTextToColumnsRequest -Delimiter $delimiter -DelimiterType $delimiterType -Source $source
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $Delimiter,
        [parameter()]
        [string]
        $DelimiterType,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.GridRange]
        $Source,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding TextToColumnsRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.TextToColumnsRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
            TextToColumn = $newRequest
        }
    }
}
