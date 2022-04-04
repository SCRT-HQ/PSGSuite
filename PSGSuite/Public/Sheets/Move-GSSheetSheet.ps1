function Move-GSSheetSheet {
    <#
    .SYNOPSIS
    Moves an existing Sheet within an existing SpreadSheet

    .DESCRIPTION
    Moves an existing Sheet within an existing SpreadSheet

    .PARAMETER SpreadsheetId
    The unique Id of the SpreadSheet

    .PARAMETER Title
    The title of the SpreadSheet Sheet to move

    .PARAMETER SheetId
    The SheetId of the SpreadSheet Sheet to move

    .PARAMETER Index
    The location to move the sheet to.
    Location starts at 0. If not specified, sheet will move to the end of the sheet list

    .PARAMETER User
    The user to move the Sheet as

    .EXAMPLE
    Move-GSSheetSheet -SpreadsheetId $id -Title "Finance Sheet" -Index 0

    Moves the Sheet titled "Finance Sheet" from the Spreadsheet with id $id to the beggining of the sheet list

    .EXAMPLE
    Move-GSSheetSheet -SpreadsheetId $id -Title "Finance Sheet"

    Moves the Sheet titled "Finance Sheet" from the Spreadsheet with id $id to the end of the sheet list
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.BatchUpdateSpreadsheetResponse')]
    [cmdletbinding(DefaultParameterSetName = "Name")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [String]
        $SpreadsheetId,
        [parameter(Mandatory = $true, ParameterSetName= "Name")]
        [Alias('SheetName')]
        [String]
        $Title,
        [parameter(Mandatory = $true, ParameterSetName= "Id")]
        [Int]
        $SheetId,
        [parameter(Mandatory = $false)]
        [System.Nullable[int]]
        $Index,
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
            }
            elseif ($SheetId) {
                $sheetProperties = $sheetInfo.Sheets.Properties | Where-Object SheetId -eq $SheetId
                if (-not $sheetProperties) {
                    throw "No Sheet found with Id $SheetId"
                }
            }
            if (-not $sheetProperties) {
                throw "No sheet found"
            }
            # Will throw error if Index exceeds existing range, so assume a large number means "the end"
            # Library documentation states:
            #   if this field is excluded then the sheet is added or moved to the end of the sheet list.
            # While this holds true when creating a sheet, when moving it, if Index is not set, it will move to the front
            # This corrects that behavior to align with the API description.
            # If no index is specified, it will set the index to move the sheet to the end.
            if ((-not $Index) -or $Index -gt $sheetInfo.Sheets.Properties.Index.Count) {
                $Index = $sheetInfo.Sheets.Properties.Index.Count
            }
            $sheetProperties.Index = $Index
            $updateSheetRequest = Add-GSSheetUpdateSheetPropertiesRequest -Fields 'Index' -Properties $sheetProperties

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
