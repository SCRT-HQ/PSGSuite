function Add-GSSheetSheet {
    <#
    .SYNOPSIS
    Creates a new Sheet on an existing SpreadSheet

    .DESCRIPTION
    Creates a new Sheet on an existing SpreadSheet

    .PARAMETER SpreadsheetId
    The unique Id of the SpreadSheet to add a Sheet to

    .PARAMETER Title
    The title of the new SpreadSheet Sheet

    .PARAMETER Index
    The location of the new sheet, starting at 0. If left blank, sheet will be created at the end of the list.

    .PARAMETER User
    The user to create the Sheet for

    .EXAMPLE
    Add-GSSheetSheet -SpreadsheetId $id -Title "Finance Sheet" -Launch

    Creates a new SpreadSheet Sheet titled "Finance Sheet" in the Spreadsheet with id of $id and opens it in the browser on creation
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.SheetProperties')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [String]
        $SpreadsheetId,
        [parameter(Mandatory = $false)]
        [Alias('SheetName')]
        [String]
        $Title,
        [parameter(Mandatory = $false)]
        [Int]
        $Index,
        [parameter(Mandatory = $false)]
        [switch]
        $Launch,
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
            $sheetProperties = Add-GSSheetSheetProperties
            if ($Title) {
                $sheetProperties.Title = $Title
            }
            if ($Index) {
                $sheetProperties.Index = $Index
            }
            $addSheetRequest = Add-GSSheetAddSheetRequest -Properties $sheetProperties
            $response = Submit-GSSheetBatchUpdate -SpreadsheetId $SpreadsheetId -Requests $addSheetRequest -User $User -IncludeSpreadsheetInResponse:$Launch
            if ($Launch) {
                $sheetUrl = $response.UpdatedSpreadsheet.SpreadsheetUrl + "#gid=" + $response.Replies[0].AddSheet.Properties.SheetId
                Write-Verbose "Launching spreadsheet at $sheetUrl"
                Start-Process $sheetUrl
            }
            $response.Replies[0].AddSheet.Properties | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
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
