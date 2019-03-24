function Add-GSSlideReplaceAllTextRequest {
    <#
    .SYNOPSIS
    Creates a ReplaceAllTextRequest to pass to Submit-GSSlideBatchUpdate.

    .DESCRIPTION
    Creates a ReplaceAllTextRequest to pass to Submit-GSSlideBatchUpdate.

    .PARAMETER ContainsText
    Accepts the following type: [Google.Apis.Slides.v1.Data.SubstringMatchCriteria].

    To create this type, use the function Add-GSSlideSubstringMatchCriteria or instantiate the type directly via New-Object 'Google.Apis.Slides.v1.Data.SubstringMatchCriteria'.

    .PARAMETER PageObjectIds
    Accepts the following type: [System.Collections.Generic.IList[string]].

    .PARAMETER ReplaceText
    Accepts the following type: [string].

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSlideReplaceAllTextRequest -ContainsText $containsText -PageObjectIds $pageObjectIds -ReplaceText $replaceText
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Slides.v1.Data.SubstringMatchCriteria]
        $ContainsText,
        [parameter()]
        [System.Collections.Generic.IList[string]]
        $PageObjectIds,
        [parameter()]
        [string]
        $ReplaceText,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding ReplaceAllTextRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Slides.v1.Data.ReplaceAllTextRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Slides.v1.Data.Request' -Property @{
                ReplaceAllTex = $newRequest
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
