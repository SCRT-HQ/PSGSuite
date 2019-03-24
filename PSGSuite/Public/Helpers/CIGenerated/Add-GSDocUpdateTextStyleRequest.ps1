function Add-GSDocUpdateTextStyleRequest {
    <#
    .SYNOPSIS
    Creates a UpdateTextStyleRequest to pass to Submit-GSDocBatchUpdate.

    .DESCRIPTION
    Creates a UpdateTextStyleRequest to pass to Submit-GSDocBatchUpdate.

    .PARAMETER Fields
    Accepts the following type: System.Object.

    .PARAMETER Range
    Accepts the following type: Google.Apis.Docs.v1.Data.Range.

    To create this type, use the function Add-GSDocRange or instantiate the type directly via New-Object 'Google.Apis.Docs.v1.Data.Range'.

    .PARAMETER TextStyle
    Accepts the following type: Google.Apis.Docs.v1.Data.TextStyle.

    To create this type, use the function Add-GSDocTextStyle or instantiate the type directly via New-Object 'Google.Apis.Docs.v1.Data.TextStyle'.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

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
        try {
            New-Object 'Google.Apis.Docs.v1.Data.Request' -Property @{
                UpdateTextStyl = $newRequest
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
