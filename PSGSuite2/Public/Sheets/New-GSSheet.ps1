function New-GSSheet {
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
        [Alias('Launch','Open')]
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
    }
    Process {
        try {
            $body = New-Object 'Google.Apis.Sheets.v4.Data.Spreadsheet'
            $body.Properties = New-Object 'Google.Apis.Sheets.v4.Data.SpreadsheetProperties' -Property @{
                Title = $Title
            }
            if (!$Title) {
                $Title = "Untitled spreadsheet"
            }
            Write-Verbose "Creating Spreadsheet '$Title' for user '$User'"
            $request = $service.Spreadsheets.Create($body)
            $response = $request.Execute() | Select-Object @{N = 'User';E = {$User}},*
            if ($Launch) {
                Start-Process $response.SpreadsheetUrl
            }
            $response
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}