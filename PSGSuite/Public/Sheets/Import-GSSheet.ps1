function Import-GSSheet {
    <#
    .SYNOPSIS
    Imports data from a Sheet as if it was a CSV

    .DESCRIPTION
    Imports data from a Sheet as if it was a CSV.
    Google Sheets are "Spreadsheets" that are comprised of one or more "Sheets".
    Sheets are the name for the "tabs" you would see at the bottom of a Spreadsheet file.

    .PARAMETER SpreadsheetId
    The unique Id of the SpreadSheet to import data from

    .PARAMETER SheetName
    The name of the Sheet to import data from.
    One or more of SheetName and Range must be specified.
    SheetName is the simpler option, and will import all data from that specific sheet.

    .PARAMETER User
    The owner of the SpreadSheet

    .PARAMETER Range
    The specific range to import data from.
    One or more of Range and SheetName must be specified.
    Range can be specified in addition to SheetName to construct the Range that is queryed.
    Range can also be specified on its own, this is an advanced option and will require some knowledge of the Sheets API.

    .PARAMETER RowStart
    The starting row of data. Useful if the headers for your table are not in Row 1 of the Sheet

    .PARAMETER Headers
    Allows you to define the headers for the rows on the sheet, in case there is no header row

    .PARAMETER DateTimeRenderOption
    How to render the DateTime cells

    Available values are:
    * "FORMATTED_STRING" (Default)
    * "SERIAL_NUMBER"

    .PARAMETER ValueRenderOption
    How to render the value cells and formula cells

    Available values are:
    * "FORMATTED_VALUE" (Default)
    * "UNFORMATTED_VALUE"
    * "FORMULA"

    .PARAMETER MajorDimension
    The major dimension that results should use.

    For example, if the spreadsheet data is: A1=1,B1=2,A2=3,B2=4, then requesting range=A1:B2,majorDimension=ROWS will return [[1,2],[3,4]], whereas requesting range=A1:B2,majorDimension=COLUMNS will return [[1,3],[2,4]].

    Available values are:
    * "ROWS" (Default)
    * "COLUMNS"
    * "DIMENSION_UNSPECIFIED"

    .PARAMETER As
    Whether to return the result set as an array of PSObjects or an array of DataRows

    Available values are:
    * "PSObject" (Default)
    * "DataRow"

    .PARAMETER Raw
    If $true, return the raw response, otherwise, return a flattened response for readability

    .EXAMPLE
    Import-GSSheet -SpreadsheetId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976' -SheetName Sheet1 -RowStart 2 -Range 'B:C'

    Imports columns B-C as an Array of PSObjects, skipping the first row and treating Row 2 as the header row. Objects in the array will be what's contained in range 'B3:C' after that

    .EXAMPLE
    Import-GSSheet -SpreadsheetId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976' -SheetName Sheet1

    Imports the entire sheet (or "tab") titled Sheet1. Under the hood, this sets a range of "Sheet1" for the API

    .EXAMPLE
    Import-GSSheet -SpreadsheetId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976' -SheetName Sheet1 -Range 'A:C'

    Imports only the first 3 columns of the sheet (or "tab") titled Sheet1. Under the hood, this sets a range of "'Sheet1':A:C" for the API.

    .EXAMPLE
    Import-GSSheet -SpreadsheetId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976' -Range 'A:C'

    Imports only the first 3 columns of the sheet (or "tab") that is first in the list. Under the hood, this sets a range of "A:C" for the API.

    .EXAMPLE
    Import-GSSheet -SpreadsheetId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976' -Range 'Sheet1!A:C'

    Imports only the first 3 columns of the sheet (or "tab") titled Sheet1. Under the hood, this sets a range of "Sheet1:A:C" for the API.
    This is advanced usage, requring you to properly construct a valid Range string to be used by the API.

    .NOTES
    SheetName and Range are how the API determines which sheet (or "tab") to pull data from.
    Specifying just a SheetName is the simplest option, most closely replicationg the behavior of Import-CSV, and should work in most cases.
    If you have some knowledge of how the Sheets API works under the hood, you can additionally use Range to specify which cells on that sheet you return.

    For advanced use cases, you can construct a valid Range query yourself and pass that directly, in either A1 notation or R1C1 notation.
    Google has documentation on these notations: https://developers.google.com/sheets/api/guides/concepts#cell
    #>
    [cmdletbinding(DefaultParameterSetName = "Import")]
    Param
    (
        [parameter(Mandatory = $true)]
        [String]
        $SpreadsheetId,
        [parameter(Mandatory = $false)]
        [String]
        $SheetName,
        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Alias('SpecifyRange')]
        [string]
        $Range,
        [parameter(Mandatory = $false)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false,ParameterSetName = "Import")]
        [int]
        $RowStart = 1,
        [parameter(Mandatory = $false,ParameterSetName = "Import")]
        [string[]]
        $Headers,
        [parameter(Mandatory = $false)]
        [ValidateSet("FORMATTED_STRING","SERIAL_NUMBER")]
        [string]
        $DateTimeRenderOption = "FORMATTED_STRING",
        [parameter(Mandatory = $false)]
        [ValidateSet("FORMATTED_VALUE","UNFORMATTED_VALUE","FORMULA")]
        [string]
        $ValueRenderOption = "FORMATTED_VALUE",
        [parameter(Mandatory = $false)]
        [ValidateSet("ROWS","COLUMNS","DIMENSION_UNSPECIFIED")]
        [string]
        $MajorDimension = "ROWS",
        [parameter(Mandatory = $false,ParameterSetName = "Import")]
        [ValidateSet("DataRow","PSObject")]
        [string]
        $As = "PSObject",
        [parameter(Mandatory = $false,ParameterSetName = "Raw")]
        [switch]
        $Raw
    )
    Begin {
        if ($User -ceq 'me') {
            $User = $Script:PSGSuite.AdminEmail
        }
        elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
        }
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/drive'
            ServiceType = 'Google.Apis.Sheets.v4.SheetsService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            if ($SheetName) {
                if ($Range -like "'*'!*") {
                    throw "SpecifyRange formatting error! When using the SheetName parameter, please exclude the SheetName when formatting the SpecifyRange value (i.e. 'A1:Z1000')"
                }
                elseif ($Range) {
                    $Range = "'$($SheetName)'!$Range"
                }
                else {
                    $Range = "$SheetName"
                }
            }
            if (-not ($SheetName -or $Range)) {
                throw "Neither SheetName nor Range was specified, one or both must be specified. SheetName refers to the `"sheets`" or tabs at the bottom of a Spreadsheet, not the title of the Spreadsheet."
            }
            $request = $service.Spreadsheets.Values.BatchGet($SpreadsheetId)
            $request.Ranges = [Google.Apis.Util.Repeatable[String]]::new([String[]]$Range)
            $request.DateTimeRenderOption = [Google.Apis.Sheets.v4.SpreadsheetsResource+ValuesResource+GetRequest+DateTimeRenderOptionEnum]::$($DateTimeRenderOption -replace "_","")
            $request.ValueRenderOption = [Google.Apis.Sheets.v4.SpreadsheetsResource+ValuesResource+GetRequest+ValueRenderOptionEnum]::$($ValueRenderOption -replace "_","")
            $request.MajorDimension = [Google.Apis.Sheets.v4.SpreadsheetsResource+ValuesResource+GetRequest+MajorDimensionEnum]::$($MajorDimension -replace "_","")
            if ($MajorDimension -ne "ROWS" -and !$Raw) {
                $Raw = $true
                Write-Warning "Setting -Raw to True -- Parsing requires the MajorDimension to be set to ROWS (default value)"
            }
            Write-Verbose "Importing Range '$Range' from Spreadsheet '$SpreadsheetId' for user '$User'"
            try {
                $response = $request.Execute()
            }
            catch {
                if ($_.Exception.Message -match 'Unable to parse range: [^"]*') {
                    write-warning $_.Exception.Message
                    $errMsg = $Matches.0
                    $file = Get-GSSheetInfo -SpreadsheetId $SpreadsheetId -User $User
                    if ((($Range -match "'$($file.Title)'!?") -or ($Range -eq $file.Title)) -and ($Range.Split('!')[0] -notin $file.Sheets.Properties.Title)) {
                        throw "$errMsg. It looks like you may have specified the name of the Spreadsheet as Sheetname, rather than one of the individual sheets (or `"tabs`") of the Spreadsheet"
                    }
                    else {
                        throw "$errMsg. Check that you specified an accurate Sheetname with your request."
                    }
                }
                else {
                    throw $_
                }
            }
            if (!$Raw) {
                $i = 0
                $datatable = New-Object System.Data.Datatable
                if ($Headers) {
                    foreach ($col in $Headers) {
                        [void]$datatable.Columns.Add("$col")
                    }
                    $i++
                }
                $(if ($RowStart) {
                        $response.valueRanges.values | Select-Object -Skip $([int]$RowStart - 1)
                    }
                    else {
                        $response.valueRanges.values
                    }) | ForEach-Object {
                    if ($i -eq 0) {
                        foreach ($col in $_) {
                            [void]$datatable.Columns.Add("$col")
                        }
                    }
                    else {
                        [void]$datatable.Rows.Add([String[]]$_[0..($datatable.Columns.Count - 1)])
                    }
                    $i++
                }
                switch ($As) {
                    DataRow {
                        Write-Verbose "Created DataTable with $($i - 1) DataRows"
                        $datatable
                    }
                    PSObject {
                        Write-Verbose "Created PSObject array with $($i - 1) objects"
                        foreach ($row in $datatable) {
                            $obj = [Ordered]@{}
                            $props = $row.Table.Columns.ColumnName
                            foreach ($prop in $props) {
                                $obj[$prop] = $row.$prop
                            }
                            [PSCustomObject]$obj
                        }
                    }
                }
            }
            else {
                $response | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
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
