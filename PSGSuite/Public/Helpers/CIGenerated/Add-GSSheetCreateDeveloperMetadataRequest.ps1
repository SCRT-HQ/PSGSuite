function Add-GSSheetCreateDeveloperMetadataRequest {
    <#
    .SYNOPSIS
    Creates a CreateDeveloperMetadataRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a CreateDeveloperMetadataRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER DeveloperMetadata
    Accepts the following type: [Google.Apis.Sheets.v4.Data.DeveloperMetadata].

    To create this type, use the function Add-GSSheetDeveloperMetadata or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.DeveloperMetadata'.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSheetCreateDeveloperMetadataRequest -DeveloperMetadata $developerMetadata
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.DeveloperMetadata]
        $DeveloperMetadata,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding CreateDeveloperMetadataRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.CreateDeveloperMetadataRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
                CreateDeveloperMetadata = $newRequest
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
