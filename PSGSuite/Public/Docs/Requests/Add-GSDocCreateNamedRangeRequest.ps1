function Add-GSDocCreateNamedRangeRequest {
    <#
    .SYNOPSIS
    Creates a CreateNamedRangeRequest to pass to Submit-GSDocBatchUpdate.

    .DESCRIPTION
    Creates a CreateNamedRangeRequest to pass to Submit-GSDocBatchUpdate.

    .PARAMETER Name
    Accepts the following type: string

    .PARAMETER Range
    Accepts the following type: Google.Apis.Docs.v1.Data.Range

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
        New-Object 'Google.Apis.Docs.v1.Data.Request' -Property @{
            CreateNamedRang = $newRequest
        }
    }
}
