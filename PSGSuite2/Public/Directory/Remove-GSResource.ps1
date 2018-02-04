function Remove-GSResource {
    <#
    .SYNOPSIS
    Removes a resource
    
    .DESCRIPTION
    Removes a resource
    
    .PARAMETER ResourceId
    The Resource Id of the Resource *Calendar* you would like to remove
    
    .PARAMETER BuildingId
    The Building Id of the Resource *Building* you would like to remove
    
    .PARAMETER FeatureKey
    The Feature Key of the Resource *Feature* you would like to remove
    
    .EXAMPLE
    Remove-GSResource -ResourceId Train01

    Removes the Resource Calendar 'Train01'
    #>
    [CmdletBinding(SupportsShouldProcess = $true,ConfirmImpact = "High",DefaultParameterSetName = 'Calendars')]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true,ParameterSetName = 'Calendars')]
        [Alias('CalendarResourceId')]
        [String[]]
        $ResourceId,
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true,ParameterSetName = 'Buildings')]
        [String[]]
        $BuildingId,
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true,ParameterSetName = 'Features')]
        [Alias('Name')]
        [String[]]
        $FeatureKey
    )
    Begin {
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/admin.directory.resource.calendar'
            ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            switch ($PSCmdlet.ParameterSetName) {
                Calendars {
                    $Resource = 'Calendars'
                    $list = $ResourceId
                }
                Buildings {
                    $Resource = 'Buildings'
                    $list = $BuildingId
                }
                Features {
                    $Resource = 'Features'
                    $list = $FeatureKey
                }
            }
            foreach ($I in $list) {
                if ($PSCmdlet.ShouldProcess("Deleting Resource $Resource Id '$I'")) {
                    Write-Verbose "Deleting Resource $Resource Id '$I'"
                    $request = $service.Resources.$Resource.Delete($(if($Script:PSGSuite.CustomerID){$Script:PSGSuite.CustomerID}else{'my_customer'}),$I)
                    $request.Execute()
                    Write-Verbose "Resource $Resource Id '$I' has been successfully deleted"
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}