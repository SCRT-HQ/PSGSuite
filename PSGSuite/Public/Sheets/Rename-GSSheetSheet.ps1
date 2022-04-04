function Rename-GSSheetSheet {
    <#
    .SYNOPSIS
    Renames an existing Sheet within an existing SpreadSheet

    .DESCRIPTION
    Renames an existing Sheet within an existing SpreadSheet

    .PARAMETER SpreadsheetId
    The unique Id of the SpreadSheet

    .PARAMETER Title
    The title of the SpreadSheet Sheet to rename

    .PARAMETER SheetId
    The SheetId of the SpreadSheet Sheet to rename

    .PARAMETER NewTitle
    The New title to rename the sheet to

    .PARAMETER User
    The user to rename the Sheet as

    .EXAMPLE
    Rename-GSSheetSheet -SpreadsheetId $id -Title "Finance Sheet" -NewTitle "Marketing Sheet"

    Renames the Sheet titled "Finance Sheet" from the Spreadsheet with id $id to "Marketing Sheet"
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.BatchUpdateSpreadsheetResponse')]
    [cmdletbinding(DefaultParameterSetName = "Name")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [String]
        $SpreadsheetId,
        [parameter(Mandatory = $true, ParameterSetName= "Name")]
        [Alias('SheetName','OldTitle','OriginalTitle')]
        [String]
        $Title,
        [parameter(Mandatory = $true, ParameterSetName= "Id")]
        [Int]
        $SheetId,
        [parameter(Mandatory = $true)]
        [String]
        $NewTitle,
        [parameter(Mandatory = $false)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail
    )
    Begin {
        if ($User -ceq 'me') {
            $User = $Script:PSGSuite.AdminEmail
        }
        elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
        }
    }
    Process {
        try {
            $sheetInfo = Get-GSSheetInfo -SpreadsheetId $SpreadsheetId -User $User
            if ($Title) {
                $sheetProperties = $sheetInfo.Sheets.Properties | Where-Object Title -eq $Title
                if (-not $sheetProperties) {
                    throw "No Sheet found with title $Title"
                }
                Write-Verbose "Found sheet with Title $($sheetProperties.Title) and SheetId $($sheetProperties.SheetId)"
            }
            elseif ($SheetId) {
                $sheetProperties = $sheetInfo.Sheets.Properties | Where-Object SheetId -eq $SheetId
                if (-not $sheetProperties) {
                    throw "No Sheet found with Id $SheetId"
                }
                Write-Verbose "Found sheet with Title $($sheetProperties.Title) and SheetId $($sheetProperties.SheetId)"
            }
            if (-not $sheetProperties) {
                throw "No sheet found"
            }
            $sheetProperties.Title = $NewTitle
            $updateSheetRequest = Add-GSSheetUpdateSheetPropertiesRequest -Fields 'Title' -Properties $sheetProperties

            Write-Verbose "Renaming sheet $($sheetProperties.SheetId) to $NewTitle"
            Submit-GSSheetBatchUpdate -SpreadsheetId $SpreadsheetId -Requests $updateSheetRequest -User $User
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
