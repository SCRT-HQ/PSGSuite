function Add-GSSheetValues {
    <#
    .SYNOPSIS
    Append data after a table of data in a sheet. This uses the native `Spreadsheets.Values.Append()` method instead of `BatchUpdate()`.

    .DESCRIPTION
    Append data after a table of data in a sheet. This uses the native `Spreadsheets.Values.Append()` method instead of `BatchUpdate()`. See the following link for more information: https://github.com/scrthq/PSGSuite/issues/216

    .PARAMETER SpreadsheetId
    The unique Id of the SpreadSheet to Append data to if updating an existing Sheet

    .PARAMETER NewSheetTitle
    The title of the new SpreadSheet to be created

    .PARAMETER Array
    Array of objects/strings/ints to append to the SpreadSheet

    .PARAMETER Value
    A single value to update 1 cell with.

    .PARAMETER SheetName
    The name of the Sheet to add the data to. If excluded, defaults to Sheet Id '0'. If a new SpreadSheet is being created, this is set to 'Sheet1' to prevent error

    .PARAMETER Style
    The table style you would like to export the data as

    Available values are:
    * "Standard": headers are on Row 1, table rows are added as subsequent rows (Default)
    * "Horizontal": headers are on Column A, table rows are added as subsequent columns

    .PARAMETER Range
    The input range is used to search for existing data and find a "table" within that range. Values are appended to the next row of the table, starting with the first column of the table.

    .PARAMETER Append
    If $true, skips adding headers to the Sheet

    .PARAMETER User
    The primary email of the user that had at least Edit rights to the target Sheet

    Defaults to the AdminEmail user

    .PARAMETER ValueInputOption
    How the input data should be interpreted

    Available values are:
    * "INPUT_VALUE_OPTION_UNSPECIFIED"
    * "RAW"
    * "USER_ENTERED"

    .PARAMETER InsertDataOption
    How the input data should be inserted.

    Available values are:
    * "OVERWRITE"
    * "INSERTROWS"

    .PARAMETER ResponseValueRenderOption
    Determines how values in the response should be rendered. The default render option is FORMATTEDVALUE.

    Available values are:
    * "FORMATTEDVALUE"
    * "UNFORMATTEDVALUE"
    * "FORMULA"

    .PARAMETER ResponseDateTimeRenderOption
    Determines how dates, times, and durations in the response should be rendered. This is ignored if responseValueRenderOption is FORMATTEDVALUE. The default dateTime render option is SERIALNUMBER.

    Available values are:
    * "SERIALNUMBER"
    * "FORMATTEDSTRING"

    .PARAMETER IncludeValuesInResponse
    Determines if the update response should include the values of the cells that were updated. By default, responses do not include the updated values

    .PARAMETER Launch
    If $true, opens the new SpreadSheet Url in your default browser

    .EXAMPLE
    Add-GSSheetValues -SpreadsheetId $sheetId -Array $items -Range 'A:Z'

    Finds the first empty row on the Sheet and appends the $items array (including header row) to it starting at that row.

    .EXAMPLE
    Add-GSSheetValues -SpreadsheetId $sheetId -Array $items -Range 'A:Z' -Append

    Finds the first empty row on the Sheet and appends the $items array (excludes header row due to -Append switch) to it starting at that row.
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Spreadsheet')]
    [cmdletbinding(DefaultParameterSetName = "CreateNewSheetArray")]
    Param
    (
        [parameter(Mandatory = $true, Position = 0, ParameterSetName = "UseExistingArray")]
        [parameter(Mandatory = $true, Position = 0, ParameterSetName = "UseExistingValue")]
        [String]
        $SpreadsheetId,
        [parameter(Mandatory = $false, Position = 0, ParameterSetName = "CreateNewSheetArray")]
        [parameter(Mandatory = $false, Position = 0, ParameterSetName = "CreateNewSheetValue")]
        [String]
        $NewSheetTitle,
        [parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true, ParameterSetName = "UseExistingArray")]
        [parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true, ParameterSetName = "CreateNewSheetArray")]
        [object[]]
        $Array,
        [parameter(Mandatory = $true, Position = 1, ParameterSetName = "UseExistingValue")]
        [parameter(Mandatory = $true, Position = 1, ParameterSetName = "CreateNewSheetValue")]
        [string]
        $Value,
        [parameter(Mandatory = $false)]
        [String]
        $SheetName,
        [parameter(Mandatory = $false, ParameterSetName = "UseExistingArray")]
        [parameter(Mandatory = $false, ParameterSetName = "CreateNewSheetArray")]
        [ValidateSet('Standard', 'Horizontal')]
        [String]
        $Style = "Standard",
        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Alias('SpecifyRange')]
        [string]
        $Range,
        [parameter(Mandatory = $false)]
        [switch]
        $Append,
        [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner', 'PrimaryEmail', 'UserKey', 'Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false)]
        [Google.Apis.Sheets.v4.SpreadsheetsResource+ValuesResource+AppendRequest+ValueInputOptionEnum]
        $ValueInputOption = [Google.Apis.Sheets.v4.SpreadsheetsResource+ValuesResource+AppendRequest+ValueInputOptionEnum]::RAW,
        [parameter(Mandatory = $false)]
        [Google.Apis.Sheets.v4.SpreadsheetsResource+ValuesResource+AppendRequest+InsertDataOptionEnum]
        $InsertDataOption = [Google.Apis.Sheets.v4.SpreadsheetsResource+ValuesResource+AppendRequest+InsertDataOptionEnum]::OVERWRITE,
        [parameter(Mandatory = $false)]
        [Google.Apis.Sheets.v4.SpreadsheetsResource+ValuesResource+AppendRequest+ResponseValueRenderOptionEnum]
        $ResponseValueRenderOption = [Google.Apis.Sheets.v4.SpreadsheetsResource+ValuesResource+AppendRequest+ResponseValueRenderOptionEnum]::FORMATTEDVALUE,
        [parameter(Mandatory = $false)]
        [Google.Apis.Sheets.v4.SpreadsheetsResource+ValuesResource+AppendRequest+ResponseDateTimeRenderOptionEnum]
        $ResponseDateTimeRenderOption = [Google.Apis.Sheets.v4.SpreadsheetsResource+ValuesResource+AppendRequest+ResponseDateTimeRenderOptionEnum]::FORMATTEDSTRING,
        [parameter(Mandatory = $false)]
        [Switch]
        $IncludeValuesInResponse,
        [parameter(Mandatory = $false)]
        [Alias('Open')]
        [Switch]
        $Launch

    )
    Begin {
        $values = New-Object 'System.Collections.Generic.List[System.Collections.Generic.IList[Object]]'
    }
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
            if ($Value) {
                $finalArray = $([pscustomobject]@{Value = "$Value" })
                $Append = $true
            }
            else {
                if (!$contentType) {
                    $contentType = $Array[0].PSObject.TypeNames[0]
                }
                $finalArray = @()
                if ($contentType -eq 'System.String' -or $contentType -like "System.Int*") {
                    $Append = $true
                    foreach ($item in $Array) {
                        $finalArray += $([pscustomobject]@{Value = $item })
                    }
                }
                else {
                    foreach ($item in $Array) {
                        $finalArray += $item
                    }
                }
            }
            if (!$Append) {
                $propArray = New-Object 'System.Collections.Generic.List[Object]'
                $finalArray[0].PSObject.Properties.Name | ForEach-Object {
                    $propArray.Add($_)
                }
                $values.Add([System.Collections.Generic.IList[Object]]$propArray)
                $Append = $true
            }
            foreach ($object in $finalArray) {
                $valueArray = New-Object 'System.Collections.Generic.List[Object]'
                $object.PSobject.Properties.Value | ForEach-Object {
                    $valueArray.Add($_)
                }
                $values.Add([System.Collections.Generic.IList[Object]]$valueArray)
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
    End {
        try {
            if ($PSCmdlet.ParameterSetName -like "CreateNewSheet*") {
                if ($NewSheetTitle) {
                    Write-Verbose "Creating new spreadsheet titled: $NewSheetTitle"
                }
                else {
                    Write-Verbose "Creating new untitled spreadsheet"
                }
                $sheet = New-GSSheet -Title $NewSheetTitle -User $User -Verbose:$false
                $SpreadsheetId = $sheet.SpreadsheetId
                $SpreadsheetUrl = $sheet.SpreadsheetUrl
                $SheetName = 'Sheet1'
                Write-Verbose "New spreadsheet ID: $SpreadsheetId"
            }
            else {
                $sheet = Get-GSSheetInfo -SpreadsheetId $SpreadsheetId -User $User -Verbose:$false
                $SpreadsheetUrl = $sheet.SpreadsheetUrl
            }
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
            $body = (New-Object 'Google.Apis.Sheets.v4.Data.ValueRange' -Property @{
                    Range          = $Range
                    MajorDimension = "$(if($Style -eq 'Horizontal'){'COLUMNS'}else{'ROWS'})"
                    Values         = [System.Collections.Generic.IList[System.Collections.Generic.IList[Object]]]$values
                })

            $request = $service.Spreadsheets.Values.Append($body, $SpreadsheetId, $Range)
            $request.valueInputOption = $ValueInputOption;
            $request.insertDataOption = $InsertDataOption;
            $request.IncludeValuesInResponse = $IncludeValuesInResponse;
            $request.responseValueRenderOption = $ResponseValueRenderOption;
            $request.responseDateTimeRenderOption = $ResponseDateTimeRenderOption;

            Write-Verbose "Appending to Range '$Range' on Spreadsheet '$SpreadsheetId' for user '$User'"
            $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru | Add-Member -MemberType NoteProperty -Name 'SpreadsheetUrl' -Value $SpreadsheetUrl -PassThru
            if ($Launch) {
                Write-Verbose "Launching new spreadsheet at $SpreadsheetUrl"
                Start-Process $SpreadsheetUrl
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
