function Add-GSContactOrganization {
    <#
    .SYNOPSIS
    Builds a Organization object to use when creating or updating a Contact

    .DESCRIPTION
    Builds a Organization object to use when creating or updating a Contact

    .PARAMETER Department
    Department within the organization

    .PARAMETER Name
    Name of the organization

    .PARAMETER Title
    Title (designation) of the user in the organization

    .PARAMETER InputObject
    Used for pipeline input of an existing UserExternalId object to strip the extra attributes and prevent errors

    .EXAMPLE
    $emails = Add-GSContactEmail -Type work -Address jsmith@contoso.com -DisplayName "John Smith | Google"
    $organizations = Add-GSContactOrganization -Title "Sales Manager" -Department "Sales" -Name "Google"

    New-GSContact -GivenName John -FamilyName Smith -Emails $email -Organizations $organizations 

    Creates a contact named John Smith and adds their work address, work phone, login_id and alternate non gsuite work email to the Contact object.

    .NOTES
    Author: Chris O'Sullivan / CompareCloud
    Acknowledgements: Used existing Add-GSUserOrganization function scructure and format to maintain convention
    Date: 6 Oct 2020
    Version: 1.0
    #>
    [OutputType('Google.Apis.PeopleService.v1.Data.Organization')]
    [CmdletBinding(DefaultParameterSetName = "InputObject")]
    Param
    (
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $Department,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $Name,
        [Parameter(Mandatory = $false, ParameterSetName = "Fields")]
        [String]
        $Title,
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = "InputObject")]
        [Google.Apis.PeopleService.v1.Data.Organization[]]
        $InputObject
    )
    Begin {
        $propsToWatch = @(
            'Department'
            'Name'
            'Title'
        )
    }
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Fields {
                    $obj = New-Object 'Google.Apis.PeopleService.v1.Data.Organization'
                    foreach ($prop in $PSBoundParameters.Keys | Where-Object {$obj.PSObject.Properties.Name -contains $_}) {
                        $obj.$prop = $PSBoundParameters[$prop]
                    }
                    $obj
                }
                InputObject {
                    foreach ($iObj in $InputObject) {
                        $obj = New-Object 'Google.Apis.PeopleService.v1.Data.Organization'
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
