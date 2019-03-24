function Add-GSDocDeleteParagraphBulletsRequest {
    <#
    .SYNOPSIS
    Creates a DeleteParagraphBulletsRequest to pass to Submit-GSDocBatchUpdate.

    .DESCRIPTION
    Creates a DeleteParagraphBulletsRequest to pass to Submit-GSDocBatchUpdate.

    .PARAMETER Range
    Accepts the following type: Google.Apis.Docs.v1.Data.Range

    .EXAMPLE
    Add-GSDocDeleteParagraphBulletsRequest -Range $range
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
        Write-Verbose "Adding DeleteParagraphBulletsRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Docs.v1.Data.DeleteParagraphBulletsRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Docs.v1.Data.Request' -Property @{
            DeleteParagraphBull = $newRequest
        }
    }
}
