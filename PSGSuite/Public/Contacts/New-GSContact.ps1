function New-GSContact {
    <#
    .SYNOPSIS
    Creates a new G Suite Contact

    .DESCRIPTION
    Creates a new G Suite Contact

    .PARAMETER GivenName
    The given (first) name of the Contact

    .PARAMETER FamilyName
    The family (last) name of the Contact

    .PARAMETER Emails
    The email objects of the Contact

    This parameter expects a 'Google.Apis.PeopleService.v1.Data.EmailAddress[]' object type. You can create objects of this type easily by using the function 'Add-GSContactEmail'

    .PARAMETER Organizations
    The organization objects of the Contact

    This parameter expects a 'Google.Apis.PeopleService.v1.Data.Organization[]' object type. You can create objects of this type easily by using the function 'Add-GSContactOrganization'

    .EXAMPLE
    $emails = Add-GSContactEmail -Type work -Address jsmith@contoso.com -DisplayName "John Smith | Google"
    $organizations = Add-GSContactOrganization -Title "Sales Manager" -Department "Sales" -Name "Google"

    New-GSContact -GivenName John -FamilyName Smith -Emails $email -Organizations $organizations 

    Creates a contact named John Smith and adds their work address, work phone, login_id and alternate non gsuite work email to the Contact object.

    .NOTES
    Author: Chris O'Sullivan / CompareCloud
    Acknowledgements: Used existing New-GSUser function scructure and format to maintain convention
    Date: 6 Oct 2020
    Version: 1.0
    #>
    [OutputType('Google.Apis.PeopleService.v1.Data.Person')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true)]
        [String]
        $GivenName,
        [parameter(Mandatory = $true)]
        [String]
        $FamilyName,
        [parameter(Mandatory = $false)]
        [Google.Apis.PeopleService.v1.Data.EmailAddress[]]
        $EmailAddresses,
        [parameter(Mandatory = $false)]
        [Google.Apis.PeopleService.v1.Data.Organization[]]
        $Organizations
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/contacts'
            ServiceType = 'Google.Apis.PeopleService.v1.PeopleServiceService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            Write-Verbose "Creating contact '$PrimaryEmail'"
            $body = New-Object 'Google.Apis.PeopleService.v1.Data.Person'
            $name = New-Object 'Google.Apis.PeopleService.v1.Data.Name' -Property @{
                GivenName  = $GivenName
                FamilyName = $FamilyName
            }
			$nameList = New-Object 'System.Collections.Generic.List`1[Google.Apis.PeopleService.v1.Data.Name]'
            $nameList.Add($name)
			
            $body.Names = $nameList
            foreach ($prop in $PSBoundParameters.Keys | Where-Object {$body.PSObject.Properties.Name -contains $_}) {
                switch ($prop) {
                    EmailAddresses {
                        $emailList = New-Object 'System.Collections.Generic.List`1[Google.Apis.PeopleService.v1.Data.EmailAddress]'
                        foreach ($email in $EmailAddresses) {
                            $emailList.Add($email)
                        }
                        $body.EmailAddresses = $emailList
                    }
                    Organizations {
                        $orgList = New-Object 'System.Collections.Generic.List`1[Google.Apis.PeopleService.v1.Data.Organization]'
                        foreach ($organization in $Organizations) {
                            $orgList.Add($organization)
                        }
                        $body.Organizations = $orgList
                    }
                    Default {
                        $body.$prop = $PSBoundParameters[$prop]
                    }
                }
            }
            $request = $service.People.CreateContact($body)
            $request.Execute()
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

