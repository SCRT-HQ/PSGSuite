function Add-GSSheetFindReplaceRequest {
    <#
    .SYNOPSIS
    Creates a FindReplaceRequest to pass to Submit-GSSheetBatchUpdate.

    .DESCRIPTION
    Creates a FindReplaceRequest to pass to Submit-GSSheetBatchUpdate.

    .PARAMETER AllSheets
    Accepts the following type: System.Nullable[bool].

    .PARAMETER Find
    Accepts the following type: string.

    .PARAMETER IncludeFormulas
    Accepts the following type: System.Nullable[bool].

    .PARAMETER MatchCase
    Accepts the following type: System.Nullable[bool].

    .PARAMETER MatchEntireCell
    Accepts the following type: System.Nullable[bool].

    .PARAMETER Range
    Accepts the following type: Google.Apis.Sheets.v4.Data.GridRange.

    To create this type, use the function Add-GSSheetGridRange or instantiate the type directly via New-Object 'Google.Apis.Sheets.v4.Data.GridRange'.

    .PARAMETER Replacement
    Accepts the following type: string.

    .PARAMETER SearchByRegex
    Accepts the following type: System.Nullable[bool].

    .PARAMETER SheetId
    Accepts the following type: System.Nullable[int].

    .PARAMETER Requests
    Enables pipeline input of other requests of the same type.

    .EXAMPLE
    Add-GSSheetFindReplaceRequest -AllSheets $allSheets -Find $find -IncludeFormulas $includeFormulas -MatchCase $matchCase -MatchEntireCell $matchEntireCell -Range $range -Replacement $replacement -SearchByRegex $searchByRegex -SheetId $sheetId
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Request')]
    [CmdletBinding()]
    Param(
        [parameter()]
        [System.Nullable[bool]]
        $AllSheets,
        [parameter()]
        [string]
        $Find,
        [parameter()]
        [System.Nullable[bool]]
        $IncludeFormulas,
        [parameter()]
        [System.Nullable[bool]]
        $MatchCase,
        [parameter()]
        [System.Nullable[bool]]
        $MatchEntireCell,
        [parameter()]
        [Google.Apis.Sheets.v4.Data.GridRange]
        $Range,
        [parameter()]
        [string]
        $Replacement,
        [parameter()]
        [System.Nullable[bool]]
        $SearchByRegex,
        [parameter()]
        [System.Nullable[int]]
        $SheetId,
        [parameter(ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests
    )
    Begin {
        Write-Verbose "Adding FindReplaceRequest to the pipeline"
    }
    Process {
        $Requests
    }
    End {
        $newRequest = New-Object 'Google.Apis.Sheets.v4.Data.FindReplaceRequest'
        foreach ($prop in $PSBoundParameters.Keys | Where-Object {$newRequest.PSObject.Properties.Name -contains $_}) {
            $newRequest.$prop = $PSBoundParameters[$prop]
        }
        try {
            New-Object 'Google.Apis.Sheets.v4.Data.Request' -Property @{
                FindReplac = $newRequest
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
