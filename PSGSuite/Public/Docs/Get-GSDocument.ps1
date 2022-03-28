function Get-GSDocument {
    <#
    .SYNOPSIS
    Retrieves a Document

    .DESCRIPTION
    Retrieves a Document, in the form of a Google.Apis.Docs.v1.Data.Document object representing the document

    .PARAMETER DocumentId
    The unique Id of the Document

    .PARAMETER User
    The primary email of the user that has at least View rights to the target Document

    Defaults to the AdminEmail user

    .PARAMETER Launch
    If $true, opens the Document Url in your default browser

    .OUTPUTS
    Google.Apis.Docs.v1.Data.Document
    An overview of the properties of a Document are available here: https://developers.google.com/docs/api/reference/rest/v1/documents

    .EXAMPLE
    $document = Get-GSDocument -DocumentID $ID

    #>
    [OutputType('Google.Apis.Docs.v1.Data.Document')]
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
        [String]
        $DocumentId,
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
            ServiceType = 'Google.Apis.Docs.v1.DocsService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
    }

    process {
        try {
            $request = $service.Documents.Get($DocumentId)
            Write-Verbose "Getting Document '$DocumentId' for user '$User'"
            $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
            if ($Launch) {
                $document = Get-GSDriveFile -FileId $DocumentId
                $DocumentUrl = $document.WebViewLink
                Write-Verbose "Launching Document at $DocumentUrl"
                Start-Process $DocumentUrl
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
