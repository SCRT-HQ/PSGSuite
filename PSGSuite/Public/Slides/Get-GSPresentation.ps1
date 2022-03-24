function Get-GSPresentation {
    <#
    .SYNOPSIS
    Retrieves a Presentation

    .DESCRIPTION
    Retrieves a Presentation, in the form of a Google.Apis.Slides.v1.Data.Presentation object representing the presentation

    .PARAMETER PresentationId
    The unique Id of the Presentation

    .PARAMETER User
    The primary email of the user that has at least View rights to the target Presentation

    Defaults to the AdminEmail user

    .PARAMETER Launch
    If $true, opens the Presentation Url in your default browser

    .OUTPUTS
    Google.Apis.Slides.v1.Data.Presentation
    An overview of the properties of a Presentation are available here: https://developers.google.com/slides/reference/rest/v1/presentations

    .EXAMPLE
    $presentation = Get-GSPresentation -PresentationID $ID

    #>
    [OutputType('Google.Apis.Slides.v1.Data.Presentation')]
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
        [String]
        $PresentationId,
        [parameter(Mandatory = $false)]
        [Alias('Owner', 'PrimaryEmail', 'UserKey', 'Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false)]
        [Alias('Open')]
        [Switch]
        $Launch
    )
    begin {
        if ($User -ceq 'me') {
            $User = $Script:PSGSuite.AdminEmail
        } elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
        }
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/drive'
            ServiceType = 'Google.Apis.Slides.v1.SlidesService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
    }

    process {
        try {
            $request = $service.Presentations.Get($PresentationId)
            Write-Verbose "Getting Presentation '$PresentationId' for user '$User'"
            $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru | Add-Member -MemberType NoteProperty -Name 'PresentationUrl' -Value $PresentationUrl -PassThru
            if ($Launch) {
                $presentation = Get-GSDriveFile -FileId $PresentationId
                $PresentationUrl = $presentation.WebViewLink
                Write-Verbose "Launching Presentation at $PresentationUrl"
                Start-Process $PresentationUrl
            }
        } catch {
            if ($ErrorActionPreference -eq 'Stop') {
                $PSCmdlet.ThrowTerminatingError($_)
            } else {
                Write-Error $_
            }
        }
    }
    end {

    }


}
