function Edit-GSPresentation {
    <#
    .SYNOPSIS
    Updates a Presentation

    .DESCRIPTION
    Updates a Presentation. Accepts update requests created by New-GSPresentationUpdateRequest

    .PARAMETER Update
    The update requests, as created by New-GSPresentationUpdateRequest. Can either be passed as a list of updates, or updates can piped into the command

    .PARAMETER User
    The primary email of the user that had at least Edit rights to the target Sheet

    Defaults to the AdminEmail user

    .PARAMETER Launch
    If $true, opens the Presentation Url in your default browser

    .INPUTS
    Google.Apis.Slides.v1.Data.Request, created by New-GSPresentationUpdateRequest

    .OUTPUTS
    Google.Apis.Slides.v1.Data.BatchUpdatePresentationResponse
    Information about the response is availabe here: https://developers.google.com/slides/reference/rest/v1/presentations/batchUpdate#response-body
    The Replies Property will be a List of Google.Apis.Slides.v1.Data.Response, in the same order as the submitted requests

    .EXAMPLE
    $newSlide = New-GSSlideUpdateRequest -RequestType CreateSlide -RequestProperties @{}
    $newSlide | Edit-GSPresentation -PresentationID $ID #Will add one new slide at the end of the Presentation
    Edit-GSPresentation -PresentationID $ID -Update $newSlide,$newSlide #Will execute the newslide request twice, adding two new slides to the end of the Presentation

    .NOTES
    Executing multiple updates at once ensures the updates happen atomically, as one action.
    If there is a problem with one of the updates, none of them will be executed.
    If you wanted updates to happen individually, you would need to call this command multiple times, once per Update.

    #>
    [OutputType('Google.Apis.Slides.v1.Data.BatchUpdatePresentationResponse')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true, Position = 0)]
        [String]
        $PresentationId,
        [parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true)]
        [System.Collections.Generic.List[Google.Apis.Slides.v1.Data.Request]]
        $Update,
        [parameter(Mandatory = $false)]
        [Alias('Owner', 'PrimaryEmail', 'UserKey', 'Mail')]
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
        } elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
        }
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/drive'
            ServiceType = 'Google.Apis.Slides.v1.SlidesService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams

        [System.Collections.Generic.List[Google.Apis.Slides.v1.Data.Request]]$requests = @()

        $body = New-Object 'Google.Apis.Slides.v1.Data.BatchUpdatePresentationRequest' -Property @{Requests = $requests}

        $presentation = Get-GSDriveFile -FileId $PresentationId
        $PresentationUrl = $presentation.WebViewLink
    }
    Process {
        foreach ($item in $Update) {
            $requestType = ($item.psobject.Properties | Where-Object {$_.Value}).Name
            Write-Verbose "Adding Request of type $requestType to Request Body"
            $body.Requests.Add($item)
        }
    }
    End {
        try {
            $request = $service.Presentations.BatchUpdate($body, $PresentationId)
            Write-Verbose "Updating Presentation '$PresentationId' for user '$User'"
            $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru | Add-Member -MemberType NoteProperty -Name 'PresentationUrl' -Value $PresentationUrl -PassThru
            if ($Launch) {
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
}
