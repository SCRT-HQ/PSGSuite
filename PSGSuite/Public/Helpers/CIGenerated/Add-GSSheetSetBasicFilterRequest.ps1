function Add-GSSheetSetBasicFilterRequest {
    <#
    .SYNOPSIS
    Creates a SetBasicFilterRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a SetBasicFilterRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Filter
    Accepts the following type: Google.Apis.Sheets.v4.Data.BasicFilter.

    To create this type, use the function Add-GSSheetBasicFilter or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.BasicFilter'.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

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
        try {
            New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
                SetBasicFilter = $newRequest
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
