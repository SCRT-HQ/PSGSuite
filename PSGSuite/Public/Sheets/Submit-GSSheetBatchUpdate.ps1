function Submit-GSSheetBatchUpdate {
    <#
    .SYNOPSIS
    Submits a batch update request to a Google Sheet.

    .DESCRIPTION
    Submits a batch update request to a Google Sheet.
    Uses request objects created by Add-GSSheet*Request functions.

    .PARAMETER SpreadsheetId
    The unique identifier of the Sheet to be updated.

    .PARAMETER Requests
    The updates to apply to the Sheet. Updates are created with Add-GsSheet*Request functions.

    .PARAMETER IncludeSpreadsheetInResponse
    If $true, include the Spreadsheet object in the response.

    .PARAMETER ResponseIncludeGridData
    If $true, include Grid Data in response spreadsheet. Implies IncludeSpreadsheetInResponse.

    .PARAMETER ResponseRanges
    Limits the ranges included in the response spreadsheet. Implies IncludeSpreadsheetInResponse.

    .PARAMETER User
    The user to update the Sheet as.

    .PARAMETER Launch
    If $true, opens the SpreadSheet Url in your default browser after submitting the batch update request.

    .EXAMPLE
    Submit-GSSheetBatchUpdate -SpreadsheetId $Id -Requests $requests

    Updates the Spreadsheet with ID of $Id using the Requests previously created and stored as $requests
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.BatchUpdateSpreadsheetResponse')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [String]
        $SpreadsheetId,
        [parameter(Mandatory = $true,Position = 1,ValueFromPipeline = $true)]
        [Google.Apis.Sheets.v4.Data.Request[]]
        $Requests,
        [parameter(Mandatory = $false)]
        [Switch]
        $IncludeSpreadsheetInResponse,
        [parameter(Mandatory = $false)]
        [Switch]
        $ResponseIncludeGridData,
        [parameter(Mandatory = $false)]
        [String[]]
        $ResponseRanges,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false)]
        [Alias('Open')]
        [Switch]
        $Launch
    )
    Begin {
        $requestList = New-Object 'System.Collections.Generic.List[Google.Apis.Sheets.v4.Data.Request]'

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
        foreach ($request in $Requests) {
            Write-Verbose "Adding Request of type $(($item.psobject.Properties | Where-Object {$_.Value}).Name) to Request Body"
            $requestList.Add($request)
        }
    }
    End {
        try {
            $body = New-Object 'Google.Apis.Sheets.v4.Data.BatchUpdateSpreadsheetRequest' -Property @{
                Requests = $requestList
            }
            if ($IncludeSpreadsheetInResponse -or $Launch) {
                $body.IncludeSpreadsheetInResponse  = $IncludeSpreadsheetInResponse
            }
            if ($ResponseIncludeGridData) {
                $body.IncludeSpreadsheetInResponse = $true
                $body.ResponseIncludeGridData = $ResponseIncludeGridData
            }
            if ($ResponseRanges) {
                $body.IncludeSpreadsheetInResponse = $true
                $body.ResponseRanges = $ResponseRanges
            }
            Write-Verbose "Updating Spreadsheet '$SpreadsheetId' for user '$User'"
            $request = $service.Spreadsheets.BatchUpdate($body, $SpreadsheetId)
            $response = $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
            if ($Launch) {
                Write-Verbose "Launching new spreadsheet at $($response.UpdatedSpreadsheet.SpreadsheetUrl)"
                Start-Process $response.UpdatedSpreadsheet.SpreadsheetUrl
            }
            $response
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
