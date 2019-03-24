function Add-GSSheetCreateDeveloperMetadataRequest {
    <#
    .SYNOPSIS
    Creates a CreateDeveloperMetadataRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a CreateDeveloperMetadataRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER DeveloperMetadata
    Accepts the following type: Google.Apis.Sheets.v4.Data.DeveloperMetadata

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
        New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
            CreateDeveloperMetadata = $newRequest
        }
    }
}
