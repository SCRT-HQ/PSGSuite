function Add-GSSheetDeleteDeveloperMetadataRequest {
    <#
    .SYNOPSIS
    Creates a DeleteDeveloperMetadataRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a DeleteDeveloperMetadataRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER DataFilter
    Accepts the following type: Google.Apis.Sheets.v4.Data.DataFilter.

    To create this type, use the function Add-GSSheetDataFilter or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.DataFilter'.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSheetDeleteDeveloperMetadataRequest -DataFilter $dataFilter
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.DataFilter]
        $DataFilter,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding DeleteDeveloperMetadataRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.DeleteDeveloperMetadataRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
                DeleteDeveloperMetadata = $newRequest
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
