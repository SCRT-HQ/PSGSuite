function Add-GSDocInsertTextRequest {
    <#
    .SYNOPSIS
    Creates a InsertTextRequest to pass to Submit-GSDocBatchUpdate.

    .DESCRIPTION
    Creates a InsertTextRequest to pass to Submit-GSDocBatchUpdate.

    .PARAMETER EndOfSegmentLocation
    Accepts the following type: [Google.Apis.Docs.v1.Data.EndOfSegmentLocation].

    To create this type, use the function Add-GSDocEndOfSegmentLocation or instantiate the type directly via New-Object 'Google.Apis.Docs.v1.Data.EndOfSegmentLocation'.

    .PARAMETER Location
    Accepts the following type: [Google.Apis.Docs.v1.Data.Location].

    To create this type, use the function Add-GSDocLocation or instantiate the type directly via New-Object 'Google.Apis.Docs.v1.Data.Location'.

    .PARAMETER Text
    Accepts the following type: [string].

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSDocInsertTextRequest -EndOfSegmentLocation $endOfSegmentLocation -Location $location -Text $text
    #>
    [OutputType('Google.Apis.Docs.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Docs.v1.Data.EndOfSegmentLocation]
        $EndOfSegmentLocation,
        [parameter()]
        [Google.Apis.Docs.v1.Data.Location]
        $Location,
        [parameter()]
        [string]
        $Text,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Docs.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding InsertTextRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Docs.v1.Data.InsertTextRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Docs.v1.Data.Request' -Property @{
                InsertTex = $newRequest
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
