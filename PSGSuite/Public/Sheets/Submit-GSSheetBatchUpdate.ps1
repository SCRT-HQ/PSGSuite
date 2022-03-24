function Submit-GSSheetBatchUpdate {
    <#
    .SYNOPSIS
    Submits a batch update request to a Google Sheet.

    .DESCRIPTION
    Submits a batch update request to a Google Sheet.

    .PARAMETER Id
    The unique identifier of the Sheet to be updated.

    .PARAMETER Requests
    The updates to apply to the Sheet.

    .PARAMETER User
    The user to update the Sheet as.

    .PARAMETER Launch
    If $true, opens the SpreadSheet Url in your default browser after submitting the batch update request.

    .EXAMPLE
    Update-GSSheet -Title "Finance Workbook" -Launch

    Creates a new SpreadSheet titled "Finance Workbook" and opens it in the browser on creation
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Spreadsheet')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('SheetId')]
        [String]
        $Id,
        [parameter(Mandatory = $true,ValueFromPipeline = $true)]
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
        foreach ($request in $Requests) {
            $requestList.Add($request)
        }
    }
    End {
        try {
            $body = New-Object 'Google.Apis.Sheets.v4.Data.BatchUpdateSpreadsheetRequest' -Property @{
                Requests = $requestList
            }
            Write-Verbose "Updating Spreadsheet '$Title' for user '$User'"
            $request = $service.Spreadsheets.Create($body)
            $response = $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
            if ($Launch) {
                Write-Verbose "Launching new spreadsheet at $($response.SpreadsheetUrl)"
                Start-Process $response.SpreadsheetUrl
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
