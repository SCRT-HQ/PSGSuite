function Submit-GSDocBatchUpdate {
    <#
    .SYNOPSIS
    Submits a batch update request to a Google Doc.

    .DESCRIPTION
    Submits a batch update request to a Google Doc.
    Uses request objects created by Add-GSDoc*Request functions.

    .PARAMETER DocumentId
    The unique identifier of the Document to be updated.

    .PARAMETER Requests
    The updates to apply to the Document. Updates are created with Add-GSDoc*Request functions.

    .PARAMETER RequiredRevisionId
    Requires the specified RevisionId to be the current revision of the Document.
    If this is specified, and the current revision does not match this value, the update will fail.

    .PARAMETER TargetRevisionId
    Targets the Requests to the given RevisionId of the Document.
    If changes are unabled to be merged, the update will fail.

    .PARAMETER User
    The user to update the Document as.

    .PARAMETER Launch
    If $true, opens the Document Url in your default browser after submitting the batch update request.

    .EXAMPLE
    Submit-GSDocBatchUpdate -DocumentId $Id -Requests $requests

    Updates the Document with ID of $Id using the Requests previously created and stored as $requests
    #>
    [OutputType('Google.Apis.Docs.v1.Data.BatchUpdateDocumentResponse')]
    [cmdletbinding(DefaultParameterSetName = "Default")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ParameterSetName = "Default")]
        [parameter(Mandatory = $true,Position = 0,ParameterSetName = "RequiredRevision")]
        [parameter(Mandatory = $true,Position = 0,ParameterSetName = "TargetRevision")]
        [String]
        $DocumentId,
        [parameter(Mandatory = $true,Position = 1,ValueFromPipeline = $true,ParameterSetName = "Default")]
        [parameter(Mandatory = $true,Position = 1,ValueFromPipeline = $true,ParameterSetName = "RequiredRevision")]
        [parameter(Mandatory = $true,Position = 1,ValueFromPipeline = $true,ParameterSetName = "TargetRevision")]
        [Alias('Request','Updates','Update')]
        [Google.Apis.Docs.v1.Data.Request[]]
        $Requests,
        [parameter(Mandatory = $true,ParameterSetName = "RequiredRevision")]
        [String]
        $RequiredRevisionId,
        [parameter(Mandatory = $true,ParameterSetName = "TargetRevision")]
        [String]
        $TargetRevisionId,
        [parameter(Mandatory = $false,ParameterSetName = "Default")]
        [parameter(Mandatory = $false,ParameterSetName = "RequiredRevision")]
        [parameter(Mandatory = $false,ParameterSetName = "TargetRevision")]
        [Alias('Owner','PrimaryEmail','UserKey','Mail')]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false,ParameterSetName="Default")]
        [parameter(Mandatory = $false,ParameterSetName="RequiredRevision")]
        [parameter(Mandatory = $false,ParameterSetName="TargetRevision")]
        [Alias('Open')]
        [Switch]
        $Launch
    )
    Begin {
        $requestList = New-Object 'System.Collections.Generic.List[Google.Apis.Docs.v1.Data.Request]'

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

        if ($Launch) {
            $document = Get-GSDriveFile -FileId $DocumentId -User $User
            $DocumentUrl = $document.WebViewLink
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
            $body = New-Object 'Google.Apis.Docs.v1.Data.BatchUpdateDocumentRequest' -Property @{
                Requests = $requestList
            }
            if ($RequiredRevisionId) {
                $writeControl = New-Object 'Google.Apis.Docs.v1.Data.WriteControl' -Property @{RequiredRevisionId = $RequiredRevisionId}
                $body.WriteControl = $writeControl
            }
            elseif ($TargetRevisionId) {
                $writeControl = New-Object 'Google.Apis.Docs.v1.Data.WriteControl' -Property @{TargetRevisionId = $TargetRevisionId}
                $body.WriteControl = $writeControl
            }
            Write-Verbose "Updating Document '$DocumentId' for user '$User'"
            $request = $service.Documents.BatchUpdate($body, $DocumentId)
            $response = $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
            if ($Launch) {
                Write-Verbose "Launching updated Document at $DocumentUrl"
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
