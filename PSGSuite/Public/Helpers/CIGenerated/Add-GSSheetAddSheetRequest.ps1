function Add-GSSheetAddSheetRequest {
    <#
    .SYNOPSIS
    Creates a AddSheetRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a AddSheetRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER Properties
    Accepts the following type: Google.Apis.Sheets.v4.Data.SheetProperties.

    To create this type, use the function Add-GSSheetSheetProperties or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.SheetProperties'.

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSheetAddSheetRequest -Properties $properties
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [Google.Apis.Sheets.v4.Data.SheetProperties]
        $Properties,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding AddSheetRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.AddSheetRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
                AddSh = $newRequest
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
