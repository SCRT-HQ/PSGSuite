function Get-GSSheetInfo {
    <#
    .SYNOPSIS
    Gets metadata about a SpreadSheet
    
    .DESCRIPTION
    Gets metadata about a SpreadSheet
    
    .PARAMETER SpreadsheetId
    The unique Id of the SpreadSheet to retrieve info for
    
    .PARAMETER User
    The owner of the SpreadSheet
    
    .PARAMETER SheetName
    The name of the Sheet to retrieve info for
    
    .PARAMETER Range
    The specific range of the Sheet to retrieve info for
    
    .PARAMETER IncludeGridData
    Whether or not to include Grid Data in the response
    
    .PARAMETER Fields
    The fields to return in the response

    Available values are:
    * "NamedRanges"
    * "Properties"
    * "Sheets"
    * "SpreadsheetId"
    
    .PARAMETER Raw
    If $true, return the raw response, otherwise, return a flattened response for readability
    
    .EXAMPLE
    Get-GSSheetInfo -SpreadsheetId '1rhsAYTOB_vrpvfwImPmWy0TcVa2sgmQa_9u976'

    Gets the info for the SpreadSheet provided
    #>
    [cmdletbinding()]
    Param
    (      
        [parameter(Mandatory = $true)]
        [String]
        $SpreadsheetId,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false)]
        [String]
        $SheetName,
        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Alias('SpecifyRange')]
        [string]
        $Range,
        [parameter(Mandatory = $false)]
        [Switch]
        $IncludeGridData,
        [parameter(Mandatory = $false)]
        [ValidateSet("namedRanges","properties","sheets","spreadsheetId")]
        [string[]]
        $Fields,
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
            $request = $service.Spreadsheets.Get($SpreadsheetId)
            if ($Range) {
                $request.Ranges = [Google.Apis.Util.Repeatable[String]]::new([String[]]$Range)
            }
            if ($Fields) {
                $request.Fields = "$($Fields -join ",")"
            }
            elseif ($PSBoundParameters.Keys -contains 'IncludeGridData') {
                $request.IncludeGridData = $IncludeGridData
            }
            else {
                $request.IncludeGridData = $true
            }
            Write-Verbose "Getting Spreadsheet Id '$SpreadsheetId' for user '$User'"
            $response = $request.Execute()
            if (!$Raw) {
                $response = $response | Select-Object @{N = "Title";E = {$_.properties.title}},@{N = "MaxRows";E = {[int]($_.sheets.properties.gridProperties.rowCount | Sort-Object | Select-Object -Last 1)}},@{N = "MaxColumns";E = {[int]($_.sheets.properties.gridProperties.columnCount | Sort-Object | Select-Object -Last 1)}},*
            }
            $response | Select-Object @{N = 'User';E = {$User}},*

        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}