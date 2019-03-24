function Add-GSSheetUpdateDeveloperMetadataRequest {
    <#
    .SYNOPSIS
    Creates a UpdateDeveloperMetadataRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a UpdateDeveloperMetadataRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER DataFilters
    Accepts the following type: System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.DataFilter].

    .PARAMETER DeveloperMetadata
    Accepts the following type: Google.Apis.Sheets.v4.Data.DeveloperMetadata.

    To create this type, use the function Add-GSSheetDeveloperMetadata or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.DeveloperMetadata'.

    .PARAMETER Fields
    Accepts the following type: System.Object.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSheetUpdateDeveloperMetadataRequest -DataFilters $dataFilters -DeveloperMetadata $developerMetadata -Fields $fields
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Collections.Generic.IList[Google.Apis.Sheets.v4.Data.DataFilter]]
        $DataFilters,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.DeveloperMetadata]
        $DeveloperMetadata,
        [parameter()]
        [System.Object]
        $Fields,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding UpdateDeveloperMetadataRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.UpdateDeveloperMetadataRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
                UpdateDeveloperMetadata = $newRequest
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
