function Add-GSDocDeleteNamedRangeRequest {
    <#
    .SYNOPSIS
    Creates a DeleteNamedRangeRequest to pass to Submit-GSDocBatchUpdate.

    .DESCRIPTION
    Creates a DeleteNamedRangeRequest to pass to Submit-GSDocBatchUpdate.

    .PARAMETER Name
    Accepts the following type: string.

    .PARAMETER NamedRangeId
    Accepts the following type: string.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSDocDeleteNamedRangeRequest -Name $name -NamedRangeId $namedRangeId
    #>
    [OutputType('Google.Apis.Docs.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $Name,
        [parameter()]
        [string]
        $NamedRangeId,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Docs.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding DeleteNamedRangeRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Docs.v1.Data.DeleteNamedRangeRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Docs.v1.Data.Request' -Property @{
                DeleteNamedRang = $newRequest
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
