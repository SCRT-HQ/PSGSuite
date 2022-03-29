function New-GSDocument {
    <#
    .SYNOPSIS
    Creates a new Document

    .DESCRIPTION
    Creates a new Document

    .PARAMETER Title
    The name of the new Document

    .PARAMETER User
    The user to create the Document for

    .PARAMETER Launch
    If $true, opens the new Document Url in your default browser

    .EXAMPLE
    New-GSDocument -Title "Finance Document" -Launch

    Creates a new Document titled "Finance Document" and opens it in the browser on creation
    #>
    [OutputType('Google.Apis.Docs.v1.Data.Document')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,ValueFromPipeline = $true,Position = 0)]
        [String]
        $Title,
        [parameter(Mandatory = $false)]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
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
            ServiceType = 'Google.Apis.Docs.v1.DocsService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            $body = New-Object 'Google.Apis.Docs.v1.Data.Document'
            $body.Title = $Title
            if (!$Title) {
                $Title = "Untitled document"
            }
            Write-Verbose "Creating Document '$Title' for user '$User'"
            $request = $service.Documents.Create($body)
            $response = $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
            if ($Launch) {
                $DocumentUrl = (Get-GSDriveFile $response.DocumentId).WebViewLink
                Write-Verbose "Launching new document at $DocumentUrl"
                Start-Process $DocumentUrl
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
