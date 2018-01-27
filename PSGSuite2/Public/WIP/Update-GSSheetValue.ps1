function Update-GSSheetValue {
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
        [parameter(Mandatory = $true,Position = 1,ParameterSetName = "UseExistingArray")]
        [parameter(Mandatory = $true,Position = 1,ParameterSetName = "CreateNewSheetArray")]
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
        [Parameter(Mandatory = $false,ParameterSetName = "Import")]
        [ValidateSet("DataRow","PSObject")]
        [string]
        $As = "PSObject",
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
            if ($PSCmdlet.ParameterSetName -like "CreateNewSheet*") {
                if ($NewSheetTitle) {
                    Write-Verbose "Creating new spreadsheet titled: $NewSheetTitle"
                }
                else {
                    Write-Verbose "Creating new untitled spreadsheet"
                }
                $SpreadsheetId = New-GSSheet -Title $NewSheetTitle -User $User -Verbose:$false | Select-Object -ExpandProperty SpreadsheetId
                Write-Verbose "New spreadsheet ID: $SpreadsheetId"
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
            if ($Value) {
                $Array = $([pscustomobject]@{Value = "$Value"})
                $Append = $true
            }
            $values = New-Object 'System.Collections.Generic.List[System.Collections.Generic.IList[Object]]'
            if (!$Append) {
                $propArray = New-Object 'System.Collections.Generic.List[Object]'
                $Array[0].PSObject.Properties.Name | ForEach-Object {
                    $propArray.Add($_)
                }
                $values.Add([System.Collections.Generic.IList[Object]]$propArray)
            }
            foreach ($object in $Array) {
                $valueArray = New-Object 'System.Collections.Generic.List[Object]'
                $object.PSobject.Properties.Value | ForEach-Object {
                    $valueArray.Add($_)
                }
                $values.Add([System.Collections.Generic.IList[Object]]$valueArray)
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
            $request.Execute() | Select-Object @{N = 'User';E = {$User}},*
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}