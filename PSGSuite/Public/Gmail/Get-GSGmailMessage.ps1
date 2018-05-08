function Get-GSGmailMessage {
    <#
    .SYNOPSIS
    Gets Gmail message details
    
    .DESCRIPTION
    Gets Gmail message details
    
    .PARAMETER User
    The primary email of the user who owns the message

    Defaults to the AdminEmail user
    
    .PARAMETER Id
    The Id of the message to retrieve info for
    
    .PARAMETER ParseMessage
    If $true, returns the parsed raw message
    
    .PARAMETER SaveAttachmentsTo
    If the message has attachments, the path to save the attachments to. If excluded, attachments are not saved locally
    
    .PARAMETER Format
    The format of the message metadata to retrieve

    Available values are:
    * "Full"
    * "Metadata"
    * "Minimal"
    * "Raw"

    Defaults to "Full", but forces -Format as "Raw" if -ParseMessage or -SaveAttachmentsTo are used
    
    .EXAMPLE
    Get-GSGmailMessage -Id 1615f9a6ee36cb5b -ParseMessage

    Gets the full message details for the provided Id and parses out the raw MIME message content
    #>
    [cmdletbinding(DefaultParameterSetName = "Format")]
    Param
    (
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('MessageId')]
        [String[]]
        $Id,
        [parameter(Mandatory = $false,ParameterSetName = "ParseMessage")]
        [switch]
        $ParseMessage,
        [parameter(Mandatory = $false,ParameterSetName = "ParseMessage")]
        [Alias('AttachmentOutputPath','OutFilePath')]
        [ValidateScript({(Get-Item $_).PSIsContainer})]
        [string]
        $SaveAttachmentsTo,
        [parameter(Mandatory = $false,ParameterSetName = "Format")]
        [ValidateSet("Full","Metadata","Minimal","Raw")]
        [string]
        $Format = "Full"
    )
    Begin {
        if ($User -ceq 'me') {
            $User = $Script:PSGSuite.AdminEmail
        }
        elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
        }
        if ($ParseMessage) {
            $Format = "Raw"
        }
        $serviceParams = @{
            Scope       = 'https://mail.google.com'
            ServiceType = 'Google.Apis.Gmail.v1.GmailService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            foreach ($mId in $Id) {
                $request = $service.Users.Messages.Get($User,$mId)
                $request.Format = $Format
                foreach ($key in $PSBoundParameters.Keys | Where-Object {$_ -ne "Id"}) {
                    switch ($key) {
                        Default {
                            if ($request.PSObject.Properties.Name -contains $key) {
                                $request.$key = $PSBoundParameters[$key]
                            }
                        }
                    }
                }
                Write-Verbose "Getting Message Id '$mId' for user '$User'"
                $result = $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
                if ($ParseMessage) {
                    $parsed = Read-MimeMessage -String $(Convert-Base64 -From WebSafeBase64String -To NormalString -String $result.Raw) | Select-Object @{N = 'User';E = {$User}},@{N = "Id";E = {$result.Id}},@{N = "ThreadId";E = {$result.ThreadId}},@{N = "LabelIds";E = {$result.LabelIds}},@{N = "Snippet";E = {$result.Snippet}},@{N = "HistoryId";E = {$result.HistoryId}},@{N = "InternalDate";E = {$result.InternalDate}},@{N = "InternalDateConverted";E = {Convert-EpochToDate -EpochString $result.internalDate}},@{N = "SizeEstimate";E = {$result.SizeEstimate}},*
                    if ($SaveAttachmentsTo) {
                        $resPath = Resolve-Path $SaveAttachmentsTo
                        $attachments = $parsed.Attachments
                        foreach ($att in $attachments) {
                            $fileName = Join-Path $resPath $att.FileName
                            Write-Verbose "Saving attachment to path '$fileName'"
                            $stream = [System.IO.File]::Create($fileName)
                            $att.ContentObject.DecodeTo($stream)
                            $stream.Close()
                        }
                    }
                    $parsed
                }
                else {
                    $result
                }
            }
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