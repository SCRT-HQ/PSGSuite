Function Invoke-GSPaginatedRequest {
    <#
    .SYNOPSIS
    Provides a reusbale framework for executing paginated requests.

    .DESCRIPTION
    Provides a reusbale framework for executing paginated requests.

    .PARAMETER Request
    The service request object that is to be executed.

    .PARAMETER Body
    The body object that is sent with the request.
    
    The object passed to this parameter must be the same instance that was used to instatiate the request object.

    .PARAMETER PageSize
    The maximum page size. If not specified the default value is 200.

    .PARAMETER Limit
    The maximum amount of results you want returned. Exclude or set to 0 to return all results

    .EXAMPLE
    $service = New-GoogleService @serviceParams
    $Request = $service.resource.List("customers/$CustomerID")
    $Results = Invoke-GSPaginatedRequest -Request $Request

    .EXAMPLE
    $service = New-GoogleService @serviceParams
    $Body = [RequestBody]::new()
    $Request = $service.resource.List($Body, "customers/$CustomerID")
    $Results = Invoke-GSPaginatedRequest -Request $Request -Body $Body

    #>

    [CmdletBinding()]
    [OutputType([System.Object[]])]
    Param(
        [Parameter(Mandatory = $True, ParameterSetName = "GET")]
        [Parameter(Mandatory = $True, ParameterSetName = "POST")]
        [Google.Apis.Requests.ClientServiceRequest]$Request,

        [Parameter(Mandatory = $True, ParameterSetName = "POST")]
        [System.Object]$Body,

        [Parameter(Mandatory = $False, ParameterSetName = "GET")]
        [Parameter(Mandatory = $False, ParameterSetName = "POST")]
        [Int]$PageSize = 200,

        [Parameter(Mandatory = $False, ParameterSetName = "GET")]
        [Parameter(Mandatory = $False, ParameterSetName = "POST")]
        [Int]$Limit = 0
    )

    Process {

        $APIMethod = $Request.GetType().FullName
        $PayloadNoun = $Request.GetType().DeclaringType.Name -Replace "Resource$"

        Write-Verbose "Preparing paginated $($PSCmdlet.ParameterSetName) request for $APIMethod"

        # Determine the object that holds the requestParameters
        If ($PSCmdlet.ParameterSetName -eq "GET"){
            $RequestParameters = $Request
        } else {
            # We are relying on $body being the same instance that was used to instantiate $Request.
            # This allows us to change the properties attached to $body which also changes the body sent with $Request.Execute()
            $RequestParameters = $Body
        }

        # Determine the Page Size property
        ForEach ($Name in @('PageSize', 'MaxResults')){
            If (($RequestParameters | Get-Member -Name $Name -MemberType Property)){
               $PageSizeProperty = $Name
               Break
            }
        }
        If ($null -eq $PageSizeProperty){
            ThrowTerm "A PageSize property was not found on the request object."
        }
        Write-Verbose "Using '$PageSizeProperty' as the PageSize property."

        # Confirm the result limit        
        if ($Limit -gt 0 -and $PageSize -gt $Limit) {
            Write-Verbose ("Reducing PageSize from $PageSize to $Limit to meet limit with first page")
            $PageSize = $Limit
        }

        # Set the initial page size
        $RequestParameters.$PageSizeProperty = $PageSize
        
        Write-Verbose "Executing paginated $($PSCmdlet.ParameterSetName) request for $APIMethod"
        
        [int]$Retrieved = 0
        $overLimit = $false
        
        do {

            $Result = $Request.Execute()

            # Update Page Token
            $RequestParameters.PageToken = $result.NextPageToken
            
            # Determine the property that contains the results payload from the API call, do this on the first page only.
            # This assumes that there will be a single property on the returned object that contains the results payload data.
            If ($Retrieved -eq 0){

                $PayloadProperty = $Result | Get-Member -MemberType Property | Select-Object -ExpandProperty Name | Where-Object {$_ -NotMatch "^(ETag|NextPageToken|Kind)$"}
                # Confirm the property exists
                If (($PayloadProperty.count -gt 1) -or ([String]::IsNullOrEmpty($PayloadProperty))){
                    ThrowTerm "Unable to determine the result property for API method '$APIMethod' on the returned object with type '$($Result.getType().FullName)'."
                }
                Write-Verbose "Using '$PayloadProperty' as the payload property."

            }

            # Get the results from the payload property
            $Output = $Result.$PayloadProperty
            
            # Count the retrieved results
            [int]$retrieved = $Retrieved + $Output.Count
            Write-Verbose "Retrieved $Retrieved $PayloadNoun..."
            
            # Check the result limit
            if (($Limit -gt 0) -and ($Retrieved -ge $Limit)) {

                Write-Verbose "Limit reached: $Limit"
                $overLimit = $true

            } elseif (($Limit -gt 0) -and (($Retrieved + $PageSize) -gt $Limit)) {
                
                $newPageSize = $Limit - $Retrieved
                Write-Verbose ("Reducing PageSize from $PageSize to $NewPageSize to meet limit with next page" -f $PageSize, $newPageSize)
                $RequestParameters.$PageSizeProperty = $NewPageSize

            }

            # Return the results to the pipeline
            $Output

        } until ($overLimit -or !$Result.NextPageToken)

        Write-Verbose "Completed paginated $($PSCmdlet.ParameterSetName) request for $APIMethod"

    }
}