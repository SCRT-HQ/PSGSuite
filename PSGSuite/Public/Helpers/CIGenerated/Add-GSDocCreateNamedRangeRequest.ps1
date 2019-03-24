function Add-GSDocCreateNamedRangeRequest {
    <#
    .SYNOPSIS
    Creates a CreateNamedRangeRequest to pass to Submit-GSDocBatchUpdate.

    .DESCRIPTION
    Creates a CreateNamedRangeRequest to pass to Submit-GSDocBatchUpdate.

    .PARAMETER Name
    Accepts the following type: [string].

    .PARAMETER Range
    Accepts the following type: [Google.Apis.Docs.v1.Data.Range].

    To create this type, use the function Add-GSDocRange or instantiate the type directly via New-Object 'Google.Apis.Docs.v1.Data.Range'.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSDocCreateNamedRangeRequest -Name $name -Range $range
    #>
    [OutputType('Google.Apis.Docs.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $Name,
        [parameter()]
        [Google.Apis.Docs.v1.Data.Range]
        $Range,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Docs.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding CreateNamedRangeRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Docs.v1.Data.CreateNamedRangeRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Docs.v1.Data.Request' -Property @{
                CreateNamedRang = $newRequest
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
