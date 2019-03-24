function Add-GSDocUpdateParagraphStyleRequest {
    <#
    .SYNOPSIS
    Creates a UpdateParagraphStyleRequest to pass to Submit-GSDocBatchUpdate.

    .DESCRIPTION
    Creates a UpdateParagraphStyleRequest to pass to Submit-GSDocBatchUpdate.

    .PARAMETER Fields
    Accepts the following type: [System.Object].

    .PARAMETER ParagraphStyle
    Accepts the following type: [Google.Apis.Docs.v1.Data.ParagraphStyle].

    To create this type, use the function Add-GSDocParagraphStyle or instantiate the type directly via New-Object 'Google.Apis.Docs.v1.Data.ParagraphStyle'.

    .PARAMETER Range
    Accepts the following type: [Google.Apis.Docs.v1.Data.Range].

    To create this type, use the function Add-GSDocRange or instantiate the type directly via New-Object 'Google.Apis.Docs.v1.Data.Range'.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSDocUpdateParagraphStyleRequest -Fields $fields -ParagraphStyle $paragraphStyle -Range $range
    #>
    [OutputType('Google.Apis.Docs.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Object]
        $Fields,
        [parameter()]
        [Google.Apis.Docs.v1.Data.ParagraphStyle]
        $ParagraphStyle,
        [parameter()]
        [Google.Apis.Docs.v1.Data.Range]
        $Range,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Docs.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding UpdateParagraphStyleRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Docs.v1.Data.UpdateParagraphStyleRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Docs.v1.Data.Request' -Property @{
                UpdateParagraphStyl = $newRequest
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
