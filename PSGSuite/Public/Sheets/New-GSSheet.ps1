function New-GSSheet {
    <#
    .SYNOPSIS
    Creates a new SpreadSheet

    .DESCRIPTION
    Creates a new SpreadSheet

    .PARAMETER Title
    The name of the new SpreadSheet

    .PARAMETER User
    The user to create the Sheet for

    .PARAMETER Launch
    If $true, opens the new SpreadSheet Url in your default browser

    .EXAMPLE
    New-GSSheet -Title "Finance Workbook" -Launch

    Creates a new SpreadSheet titled "Finance Workbook" and opens it in the browser on creation
    #>
    [OutputType('Google.Apis.Sheets.v4.Data.Spreadsheet')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false)]
        [Alias('SheetTitle')]
        [String]
        $Title,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false)]
        [Alias('Open')]
        [Switch]
        $Launch
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
            $body = New-Object 'Google.Apis.Sheets.v4.Data.Spreadsheet'
            $body.Properties = New-Object 'Google.Apis.Sheets.v4.Data.SpreadsheetProperties' -Property @{
                Title = $Title
            }
            if (-not $Title) {
                $Title = "Untitled spreadsheet"
            }
            Write-Verbose "Creating Spreadsheet '$Title' for user '$User'"
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
