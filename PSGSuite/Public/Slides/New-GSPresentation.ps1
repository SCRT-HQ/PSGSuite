function New-GSPresentation {
    <#
    .SYNOPSIS
    Creates a new Presentation

    .DESCRIPTION
    Creates a new Presentation

    .PARAMETER Title
    The name of the new Presentation

    .PARAMETER User
    The user to create the Presentation for

    .PARAMETER Launch
    If $true, opens the new Presentation Url in your default browser

    .EXAMPLE
    New-GSPresentation -Title "Finance Presentation" -Launch

    Creates a new Presentation titled "Finance Presentation" and opens it in the browser on creation
    #>
    [OutputType('Google.Apis.Slides.v1.Data.Presentation')]
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
            ServiceType = 'Google.Apis.Slides.v1.SlidesService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            $body = New-Object 'Google.Apis.Slides.v1.Data.Presentation'
            $body.Title = $Title
            if (-not $Title) {
                $Title = "Untitled presentation"
            }
            Write-Verbose "Creating Presentation '$Title' for user '$User'"
            $request = $service.Presentations.Create($body)
            $response = $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
            if ($Launch) {
                $PresentationUrl = (Get-GSDriveFile $response.PresentationId).WebViewLink
                Write-Verbose "Launching new presentation at $PresentationUrl"
                Start-Process $PresentationUrl
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
