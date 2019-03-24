function Add-GSSheetSetBasicFilterRequest {
    <#
    .SYNOPSIS
    Creates a SetBasicFilterRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a SetBasicFilterRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Filter
    Accepts the following type: Google.Apis.Sheets.v4.Data.BasicFilter

    .EXAMPLE
    Add-GSSheetSetBasicFilterRequest -Filter $filter
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.BasicFilter]
        $Filter,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding SetBasicFilterRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.SetBasicFilterRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
            SetBasicFilter = $newRequest
        }
    }
}
