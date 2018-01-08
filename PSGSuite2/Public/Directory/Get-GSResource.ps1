function Get-GSResource {
    [CmdletBinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [String[]]
        $Id,
        [parameter(Mandatory = $false)]
        [ValidateSet('Calendars','Buildings','Features')]
        [String]
        $Resource = 'Calendars'
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
            foreach ($I in $Id) {
                Write-Verbose "Getting Resource $Resource Id '$I'"
                $request = $service.Resources.$Resource.Get($(if ($Script:PSGSuite.CustomerID){$Script:PSGSuite.CustomerID}else{'my_customer'}),$I)
                $request.Execute() | Select-Object @{N = 'Resource';E = {$Resource}},*
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}