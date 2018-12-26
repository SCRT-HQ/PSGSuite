function Clear-GSSheet {
    <#
    .SYNOPSIS
    Clears a Sheet

    .DESCRIPTION
    Clears a Sheet

    .PARAMETER SpreadsheetId
    The unique Id of the SpreadSheet

    .PARAMETER SheetName
    The name of the Sheet (tab) to clear

    .PARAMETER Range
    The specific range to clear. If excluded, clears the entire Sheet

    .PARAMETER User
    The primary email of the user who has Edit rights to the target Range/Sheet

    .PARAMETER Raw
    If $true, return the raw response, otherwise, return a flattened response for readability

    .EXAMPLE
    Clear-GSSheet -SpreadsheetId '1ZVdewVhy-VtVLyGL1lk2kgvySIF_bCfJA6ggn7obGh2U' -SheetName 2017

    Clears the Sheet '2017' located on the SpreadSheet Id provided
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Spreadsheet')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
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
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
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
            $body = New-Object 'Google.Apis.Sheets.v4.Data.ClearValuesRequest'
            $request = $service.Spreadsheets.Values.Clear($body,$SpreadsheetId,$Range)
            Write-Verbose "Clearing range '$Range' on Sheet '$SpreadsheetId' for user '$User'"
            $response = $request.Execute()
            if (!$Raw) {
                $response = $response | Select-Object @{N = "Title";E = {$_.properties.title}},@{N = "MaxRows";E = {[int]($_.sheets.properties.gridProperties.rowCount | Sort-Object | Select-Object -Last 1)}},@{N = "MaxColumns";E = {[int]($_.sheets.properties.gridProperties.columnCount | Sort-Object | Select-Object -Last 1)}},*
            }
            $response | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
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
