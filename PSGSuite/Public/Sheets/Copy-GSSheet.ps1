function Copy-GSSheet {
    <#
    .SYNOPSIS
    Copies a Sheet from one SpreadSheet to another
    
    .DESCRIPTION
    Copies a Sheet from one SpreadSheet to another
    
    .PARAMETER SourceSpreadsheetId
    The unique Id of the SpreadSheet to copy the Sheet from
    
    .PARAMETER SourceSheetId
    The Id of the Sheet to copy
    
    .PARAMETER DestinationSpreadsheetId
    The target SpreadSheet to copy the Sheet to
    
    .PARAMETER NewSheetTitle
    The new title for the new SpreadhSheet to create if not copying to a Destination Sheet
    
    .PARAMETER User
    The primary email of the user who has at least Edit rights to both the Source SpreadSheet and Destination SpreadSheet
    
    .PARAMETER Raw
    If $true, return the raw response, otherwise, return a flattened response for readability
    
    .EXAMPLE
    Copy-GSSheet -SourceSpreadsheetId '1ZVdewVhy-VtVLyGLhClkj8234ljk_fJA6ggn7obGh2U' -SourceSheetId 2017 -NewSheetTitle '2017 Archive'

    Copies the Sheet '2017' from the SourceSpreadsheet provided onto a new SpreadSheet named '2017 Archive'
    #>
    [cmdletbinding(DefaultParameterSetName = "CreateNewSheet")]
    Param
    (      
        [parameter(Mandatory = $true,Position = 0)]
        [String]
        $SourceSpreadsheetId,
        [parameter(Mandatory = $true,Position = 1)]
        [String]
        $SourceSheetId,
        [parameter(Mandatory = $true,Position = 2,ParameterSetName = "UseExisting")]
        [String]
        $DestinationSpreadsheetId,
        [parameter(Mandatory = $false,ParameterSetName = "CreateNewSheet")]
        [Alias('SheetTitle')]
        [String]
        $NewSheetTitle,
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
            if ($PSCmdlet.ParameterSetName -eq "CreateNewSheet") {
                if ($NewSheetTitle) {
                    Write-Verbose "Creating new spreadsheet titled: $NewSheetTitle"
                }
                else {
                    Write-Verbose "Creating new untitled spreadsheet"
                }
                $DestinationSpreadsheetId = New-GSSheet -Title $NewSheetTitle -User $User -Verbose:$false | Select-Object -ExpandProperty SpreadsheetId
                Write-Verbose "New spreadsheet ID: $DestinationSpreadsheetId"
            }
            $body = New-Object 'Google.Apis.Sheets.v4.Data.CopySheetToAnotherSpreadsheetRequest' -Property @{
                DestinationSpreadsheetId = $DestinationSpreadsheetId
            }
            Write-Verbose "Copying Sheet '$SourceSheetId' from Spreadsheet '$SourceSpreadsheetId' to Spreadsheet '$DestinationSpreadsheetId' for user '$User'"
            $request = $service.Spreadsheets.Sheets.CopyTo($body,$SourceSpreadsheetId,$SourceSheetId)
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