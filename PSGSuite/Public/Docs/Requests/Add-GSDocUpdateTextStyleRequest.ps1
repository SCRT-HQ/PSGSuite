function Add-GSDocUpdateTextStyleRequest {
    <#
    .SYNOPSIS
    Creates a UpdateTextStyleRequest to pass to Submit-GSDocBatchUpdate.

    .DESCRIPTION
    Creates a UpdateTextStyleRequest to pass to Submit-GSDocBatchUpdate.

    .PARAMETER Fields
    Accepts the following type: System.Object

    .PARAMETER Range
    Accepts the following type: Google.Apis.Docs.v1.Data.Range

    .PARAMETER TextStyle
    Accepts the following type: Google.Apis.Docs.v1.Data.TextStyle

    .EXAMPLE
    Add-GSDocUpdateTextStyleRequest -Fields $fields -Range $range -TextStyle $textStyle
    #>
    [OutputType('Google.Apis.Docs.v1.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Object]
        $Fields,
        [parameter()]
        [Google.Apis.Docs.v1.Data.Range]
        $Range,
        [parameter()]
        [Google.Apis.Docs.v1.Data.TextStyle]
        $TextStyle,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Docs.v1.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding UpdateTextStyleRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Docs.v1.Data.UpdateTextStyleRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        New-Object 'Google.Apis.Docs.v1.Data.Request' -Property @{
            UpdateTextStyl = $newRequest
        }
    }
}
