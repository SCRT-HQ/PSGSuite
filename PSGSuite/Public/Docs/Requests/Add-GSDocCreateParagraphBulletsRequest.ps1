function Add-GSDocCreateParagraphBulletsRequest {
    <#
    .SYNOPSIS
    Creates a CreateParagraphBulletsRequest to pass to Submit-GSDocBatchUpdate.

    .DESCRIPTION
    Creates a CreateParagraphBulletsRequest to pass to Submit-GSDocBatchUpdate.

    .PARAMETER BulletPreset
    Accepts the following type: string

    .PARAMETER Range
    Accepts the following type: Google.Apis.Docs.v1.Data.Range

    .EXAMPLE
    Add-GSDocCreateParagraphBulletsRequest -BulletPreset $bulletPreset -Range $range
    #>
    [OutputType('Google.Apis.Docs.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [string]
        $BulletPreset,
        [parameter()]
        [Google.Apis.Docs.v1.Data.Range]
        $Range,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Docs.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding CreateParagraphBulletsRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Docs.v1.Data.CreateParagraphBulletsRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Docs.v1.Data.Request' -Property @{
            CreateParagraphBull = $newRequest
        }
    }
}
