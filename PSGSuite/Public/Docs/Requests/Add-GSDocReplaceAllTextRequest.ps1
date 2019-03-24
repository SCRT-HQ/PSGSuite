function Add-GSDocReplaceAllTextRequest {
    <#
    .SYNOPSIS
    Creates a ReplaceAllTextRequest to pass to Submit-GSDocBatchUpdate.

    .DESCRIPTION
    Creates a ReplaceAllTextRequest to pass to Submit-GSDocBatchUpdate.

    .PARAMETER ContainsText
    Accepts the following type: Google.Apis.Docs.v1.Data.SubstringMatchCriteria

    .PARAMETER ReplaceText
    Accepts the following type: string

    .EXAMPLE
    Add-GSDocReplaceAllTextRequest -ContainsText $containsText -ReplaceText $replaceText
    #>
    [OutputType('Google.Apis.Docs.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Docs.v1.Data.SubstringMatchCriteria]
        $ContainsText,
        [parameter()]
        [string]
        $ReplaceText,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Docs.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding ReplaceAllTextRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Docs.v1.Data.ReplaceAllTextRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Docs.v1.Data.Request' -Property @{
            ReplaceAllTex = $newRequest
        }
    }
}
