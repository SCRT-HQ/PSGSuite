function Add-GSContactEmail {
    <#
    .SYNOPSIS
    Builds a Email object to use when creating or updating a contact

    .DESCRIPTION
    Builds a Email object to use when creating or updating a contact

    .PARAMETER Address
    The contact's email address. Also serves as the email ID. This value can be the contact's primary email address or an alias.

    .PARAMETER Type
    The type of the email account.

    Acceptable values are:
    * "home"
    * "other"
    * "work"

    .PARAMETER InputObject
    Used for pipeline input of an existing Email object to strip the extra attributes and prevent errors

    .EXAMPLE
    $emails = Add-GSContactEmail -Type work -Address jsmith@contoso.com -DisplayName "John Smith | Google"
    $organizations = Add-GSContactOrganization -Title "Sales Manager" -Department "Sales" -Name "Google"

    New-GSContact -GivenName John -FamilyName Smith -Emails $email -Organizations $organizations 

    Creates a contact named John Smith and adds their work address, work phone, login_id and alternate non gsuite work email to the Contact object.

    .NOTES
    Author: Chris O'Sullivan / CompareCloud
    Acknowledgements: Used existing Add-GSUserEmail function scructure and format to maintain convention
    Date: 6 Oct 2020
    Version: 1.0
    #>
    [OutputType('Google.Apis.PeopleService.v1.Data.EmailAddress')]
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $DisplayName,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $Value,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [ValidateSet('home', 'other', 'work')]
        [String]
        $Type,
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = "InputObject")]
        [Google.Apis.PeopleService.v1.Data.EmailAddress[]]
        $InputObject
    )
    Begin {
        $propsToWatch = @(
            'DisplayName'
            'Value'
            'Type'
        )
    }
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.PeopleService.v1.Data.EmailAddress'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        if ($prop -eq 'Type') {
                            $obj.$prop = $PSBoundParameters[$prop].ToLower()
                        }
                        else {
                            $obj.$prop = $PSBoundParameters[$prop]
                        }
                    }
                    $obj
                }
                InputObject {
                    foreach ($iObj in $InputObject) {
                        $obj = New-Object 'Google.Apis.PeopleService.v1.Data.EmailAddress'
                        foreach ($prop in $iObj.PSObject.Properties.Name | Where-Object {$obj.PSObject.Properties.Name -contains $_ -and $propsToWatch -contains $_}) {
                            $obj.$prop = $iObj.$prop
                        }
                        $obj
                    }
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
