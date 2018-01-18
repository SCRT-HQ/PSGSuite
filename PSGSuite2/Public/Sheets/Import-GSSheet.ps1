function Import-GSSheet {
    [cmdletbinding()]
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
        [parameter(Mandatory = $false)]
        [int]
        $RowStart = 1,
        [parameter(Mandatory = $false)]
        [string[]]
        $Headers,
        [parameter(Mandatory = $false)]
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
                Write-Verbose "Created DataTable object with $($i - 1) Rows"
                $datatable
            }
            else {
                $response | Select-Object @{N = 'User';E = {$User}},*
            }

        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}