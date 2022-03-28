function Submit-GSSlideBatchUpdate {
    <#
    .SYNOPSIS
    Submits a batch update request to a Google Presentation.

    .DESCRIPTION
    Submits a batch update request to a Google Presentation.
    Uses request objects created by Add-GSSlide*Request functions.

    .PARAMETER PresentationId
    The unique identifier of the Presentation to be updated.

    .PARAMETER Requests
    The updates to apply to the Presentation. Updates are created with Add-GSSlide*Request functions.

    .PARAMETER RequiredRevisionId
    Requires the specified RevisionId to be the current revision of the Presentation.
    If this is specified, and the current revision does not match this value, the update will fail.

    .PARAMETER User
    The user to update the Presentation as.

    .PARAMETER Launch
    If $true, opens the Presentation Url in your default browser after submitting the batch update request.

    .EXAMPLE
    Submit-GSSlideBatchUpdate -PresentationId $Id -Requests $requests

    Updates the Presentation with ID of $Id using the Requests previously created and stored as $requests
    #>
    [OutputType('Google.Apis.Slides.v1.Data.BatchUpdatePresentationResponse')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [String]
        $PresentationId,
        [parameter(Mandatory = $true,Position = 1,ValueFromPipeline = $true)]
        [Alias('Request','Updates','Update')]
        [Google.Apis.Slides.v1.Data.Request[]]
        $Requests,
        [parameter(Mandatory = $false)]
        [String]
        $RequiredRevisionId,
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
        $requestList = New-Object 'System.Collections.Generic.List[Google.Apis.Slides.v1.Data.Request]'

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

        if ($Launch) {
            $presentation = Get-GSDriveFile -FileId $PresentationId -User $User
            $PresentationUrl = $presentation.WebViewLink
        }
    }
    Process {
        foreach ($request in $Requests) {
            Write-Verbose "Adding Request of type $(($item.psobject.Properties | Where-Object {$_.Value}).Name) to Request Body"
            $requestList.Add($request)
        }
    }
    End {
        try {
            $body = New-Object 'Google.Apis.Slides.v1.Data.BatchUpdatePresentationRequest' -Property @{
                Requests = $requestList
            }
            if ($RequiredRevisionId) {
                $writeControl = New-Object 'Google.Apis.Slides.v1.Data.WriteControl' -Property @{RequiredRevisionId = $RequiredRevisionId}
                $body.WriteControl = $writeControl
            }
            Write-Verbose "Updating Presentation '$PresentationId' for user '$User'"
            $request = $service.Presentations.BatchUpdate($body, $PresentationId)
            $response = $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
            if ($Launch) {
                Write-Verbose "Launching updated Presentation at $PresentationUrl"
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
