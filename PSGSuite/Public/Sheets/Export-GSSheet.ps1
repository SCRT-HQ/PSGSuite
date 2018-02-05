function Export-GSSheet {
    <#
    .SYNOPSIS
    Updates a Sheet's values
    
    .DESCRIPTION
    Updates a Sheet's values. Accepts either an Array of objects/strings/ints or a single value
    
    .PARAMETER SpreadsheetId
    The unique Id of the SpreadSheet to update if updating an existing Sheet
    
    .PARAMETER NewSheetTitle
    The title of the new SpreadSheet to be created
    
    .PARAMETER Array
    Array of objects/strings/ints to add to the SpreadSheet
    
    .PARAMETER Value
    A single value to update 1 cell with. Useful if you are tracking the last time updated in a specific cell during a job that updates Sheets
    
    .PARAMETER SheetName
    The name of the Sheet to add the data to. If excluded, defaults to Sheet Id '0'. If a new SpreadSheet is being created, this is set to 'Sheet1' to prevent error
    
    .PARAMETER Style
    The table style you would like to export the data as

    Available values are:
    * "Standard": headers are on Row 1, table rows are added as subsequent rows (Default)
    * "Horizontal": headers are on Column A, table rows are added as subsequent columns
    
    .PARAMETER Range
    The specific range to add the value(s) to. If using the -Value parameter, set this to the specific cell you would like to set the value of
    
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
    
    .PARAMETER IncludeValuesInResponse
    Determines if the update response should include the values of the cells that were updated. By default, responses do not include the updated values
    
    .PARAMETER Launch
    If $true, opens the new SpreadSheet Url in your default browser
    
    .EXAMPLE
    $array | Export-GSSheet -NewSheetTitle "Finance Workbook" -Launch


    #>
    [cmdletbinding(DefaultParameterSetName = "CreateNewSheetArray")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ParameterSetName = "UseExistingArray")]
        [parameter(Mandatory = $true,Position = 0,ParameterSetName = "UseExistingValue")]
        [String]
        $SpreadsheetId,
        [parameter(Mandatory = $false,Position = 0,ParameterSetName = "CreateNewSheetArray")]
        [parameter(Mandatory = $false,Position = 0,ParameterSetName = "CreateNewSheetValue")]
        [String]
        $NewSheetTitle,
        [parameter(Mandatory = $true,Position = 1,ValueFromPipeline = $true,ParameterSetName = "UseExistingArray")]
        [parameter(Mandatory = $true,Position = 1,ValueFromPipeline = $true,ParameterSetName = "CreateNewSheetArray")]
        [object[]]
        $Array,
        [parameter(Mandatory = $true,Position = 1,ParameterSetName = "UseExistingValue")]
        [parameter(Mandatory = $true,Position = 1,ParameterSetName = "CreateNewSheetValue")]
        [string]
        $Value,
        [parameter(Mandatory = $false)]
        [String]
        $SheetName,
        [parameter(Mandatory = $false,ParameterSetName = "UseExistingArray")]
        [parameter(Mandatory = $false,ParameterSetName = "CreateNewSheetArray")]
        [ValidateSet('Standard','Horizontal')]
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
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false)]
        [ValidateSet("INPUT_VALUE_OPTION_UNSPECIFIED","RAW","USER_ENTERED")]
        [string]
        $ValueInputOption = "RAW",
        [parameter(Mandatory = $false)]
        [Switch]
        $IncludeValuesInResponse,
        [parameter(Mandatory = $false)]
        [Alias('Open')]
        [Switch]
        $Launch
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
        $values = New-Object 'System.Collections.Generic.List[System.Collections.Generic.IList[Object]]'
    }
    Process {
        try {
            if (!$contentType) {
                $contentType = $Array[0].PSObject.TypeNames[0]
            }
            if ($Value) {
                $finalArray = $([pscustomobject]@{Value = "$Value"})
                $Append = $true
            }
            else {
                $finalArray = @()
                if ($contentType -eq 'System.String' -or $contentType -like "System.Int*") {
                    $Append = $true
                    foreach ($item in $Array) {
                        $finalArray += $([pscustomobject]@{Value = $item})
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
            $bodyData = (New-Object 'Google.Apis.Sheets.v4.Data.ValueRange' -Property @{
                Range = $Range
                MajorDimension = "$(if($Style -eq 'Horizontal'){'COLUMNS'}else{'ROWS'})"
                Values = [System.Collections.Generic.IList[System.Collections.Generic.IList[Object]]]$values
            })
            $body = New-Object 'Google.Apis.Sheets.v4.Data.BatchUpdateValuesRequest'
            $body.ValueInputOption = $ValueInputOption
            $body.IncludeValuesInResponse = $IncludeValuesInResponse
            $body.Data = [Google.Apis.Sheets.v4.Data.ValueRange[]]$bodyData
            $request = $service.Spreadsheets.Values.BatchUpdate($body,$SpreadsheetId)
            Write-Verbose "Updating Range '$Range' on Spreadsheet '$SpreadsheetId' for user '$User'"
            $response = $request.Execute() | Select-Object @{N = 'User';E = {$User}},*,@{N = "SpreadsheetUrl";E = {$SpreadsheetUrl}}
            if ($Launch) {
                Write-Verbose "Launching new spreadsheet at $SpreadsheetUrl"
                Start-Process $SpreadsheetUrl
            }
            $response
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}