function Get-GSGmailMessage {
    [cmdletbinding(DefaultParameterSetName = "Format")]
    Param
    (
        [parameter(Mandatory = $false)]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('Id')]
        [String[]]
        $MessageID,
        [parameter(Mandatory = $false,ParameterSetName = "ParseMessage")]
        [switch]
        $ParseMessage,
        [parameter(Mandatory = $false,ParameterSetName = "ParseMessage")]
        [Alias('AttachmentOutputPath')]
        [ValidateScript( {Test-Path $_})]
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
            foreach ($id in $MessageID) {
                $request = $service.Users.Messages.Get($User,$id)
                $request.Format = $Format
                foreach ($key in $PSBoundParameters.Keys) {
                    switch ($key) {
                        Default {
                            if ($request.PSObject.Properties.Name -contains $key) {
                                $request.$key = $PSBoundParameters[$key]
                            }
                        }
                    }
                }
                Write-Verbose "Getting Message Id '$id' for user '$User'"
                $result = $request.Execute() | Select-Object @{N = 'User';E = {$User}},*
                if ($ParseMessage) {
                    $parsed = Read-MimeMessage -String $(Convert-Base64 -From WebSafeBase64String -To NormalString -String $result.Raw) | Select-Object @{N = "Id";E = {$result.Id}},@{N = "ThreadId";E = {$result.ThreadId}},@{N = "LabelIds";E = {$result.LabelIds}},@{N = "Snippet";E = {$result.Snippet}},@{N = "HistoryId";E = {$result.HistoryId}},@{N = "InternalDate";E = {$result.InternalDate}},@{N = "InternalDateConverted";E = {Convert-EpochToDate -EpochString $result.internalDate}},@{N = "SizeEstimate";E = {$result.SizeEstimate}},*
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
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}