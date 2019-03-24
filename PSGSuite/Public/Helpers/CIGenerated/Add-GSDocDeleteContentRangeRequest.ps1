function Add-GSDocDeleteContentRangeRequest {
    <#
    .SYNOPSIS
    Creates a DeleteContentRangeRequest to pass to Submit-GSDocBatchUpdate.

    .DESCRIPTION
    Creates a DeleteContentRangeRequest to pass to Submit-GSDocBatchUpdate.

    .PARAMETER Range
    Accepts the following type: [Google.Apis.Docs.v1.Data.Range].

    To create this type, use the function Add-GSDocRange or instantiate the type directly via New-Object 'Google.Apis.Docs.v1.Data.Range'.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSDocDeleteContentRangeRequest -Range $range
    #>
    [OutputType('Google.Apis.Docs.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Docs.v1.Data.Range]
        $Range,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Docs.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding DeleteContentRangeRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Docs.v1.Data.DeleteContentRangeRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Docs.v1.Data.Request' -Property @{
                DeleteContentRang = $newRequest
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
