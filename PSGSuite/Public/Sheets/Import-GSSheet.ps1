function Import-GSSheet {
    <#
    .SYNOPSIS
    Imports data from a Sheet as if it was a CSV

    .DESCRIPTION
    Imports data from a Sheet as if it was a CSV

    .PARAMETER SpreadsheetId
    The unique Id of the SpreadSheet to import data from

    .PARAMETER SheetName
    The name of the Sheet to import data from

    .PARAMETER User
    The owner of the SpreadSheet

    .PARAMETER Range
    The specific range to import data from

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
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Alias('SpecifyRange')]
        [string]
        $Range,
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
        [Parameter(Mandatory = $false,ParameterSetName = "Import")]
        [ValidateSet("DataRow","PSObject")]
        [string]
        $As = "PSObject",
        [parameter(Mandatory = $false,ParameterSetName = "Raw")]
        [switch]
        $Raw
    )
    Process {
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
            $response = $request.Execute()
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
                        [void]$datatable.Rows.Add([String[]]$_)
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
