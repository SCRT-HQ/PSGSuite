function New-GSPresentationUpdateRequest {
    <#
    .SYNOPSIS
    Creates an Update Request to be used with Edit-GSPresentation

    .DESCRIPTION
    Creates an Update Request to be used with Edit-GSPresentation. Does the hard work of creating a "Google.Apis.Slides.v1.Data.$($RequestType)Request"
    and generating a 'Google.Apis.Slides.v1.Data.Request' from it.

    .PARAMETER RequestType
    The type of update request, as described here: https://developers.google.com/slides/reference/rest/v1/presentations/request
    Will dynamically validate RequestType based on request types supported by the Slides API library

    .PARAMETER RequestProperties
    The properties for the specified RequestType, as described here: https://developers.google.com/slides/reference/rest/v1/presentations/request
    These properties must be strictly formatted to exactly match the parameters for the given request.

    .OUTPUTS
    Google.Apis.Slides.v1.Data.Request

    .EXAMPLE
    $newSlide = New-GSSlideUpdateRequest -RequestType CreateSlide -RequestProperties @{}
    This will create a request to create a new slide at the end of the document with a uniquely generatd ObjectId.
    The slide will be created with no layout.

    $moveSlideProperties = @{slideObjectIds = @($slideToMove.ObjectId); insertionIndex=0}
    $moveSlide = New-GSPresentationUpdateRequest -RequestType UpdateSlidesPosition -RequestProperties $moveSlideProperties
    This will move the slide specified by $slideToMove to the beggining of the Presentation.
    Note here that even though we're only moving a single slide, slideObjectIds is still set as an array, but with only a single element.

    These Request objects can then be used to update a presentation using Edit-GSPresentation
    Edit-GSPresentation -PresentationID $ID -Update $newSlide,$moveSlide
    This will create a new slide at the end, then move the earlier specified slide to the beggining of the Presentation

    #>
    [OutputType('Google.Apis.Slides.v1.Data.Request')]
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Does not change any state')]
    param (
        # Parameter help description
        [Parameter(Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $true)]
        [hashtable]
        $RequestProperties
    )

    DynamicParam {
        # Instead of hardcoding each Request Type into a validate set, or simply passing any value as the request type,
        # we will look at all the properites of a Data.Request (other than Etag) and assign that as the validate set.
        # This will ensure that if new request types are added, this function will automatically support them, and they will be available for auto complete
        $requests = ((New-Object 'Google.Apis.Slides.v1.Data.Request').psobject.Properties | Where-Object Name -ne Etag).Name
        $attributes = New-Object System.Management.Automation.ParameterAttribute
        $attributes.Mandatory = $true
        $attributes.Position = 0
        $attributes.ValueFromPipelineByPropertyName = $true
        $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $attributeCollection.Add($attributes)
        $validateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($requests)
        $attributeCollection.Add($validateSetAttribute)

        $dynParam1 = New-Object System.Management.Automation.RuntimeDefinedParameter("RequestType", [string], $attributeCollection)

        $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $paramDictionary.Add("RequestType", $dynParam1)
        $paramDictionary

    }
    begin {

    }
    process {
        try {
            $RequestType = $PSBoundParameters['RequestType'] #Because of the Dynamic Parameters, this variable won't be automatically created like a regular parameter

            # Requests that take an array of data require the data to be in a Generic.List (and will throw an unclear error if an array is used).
            # However this can be cumbersome to construct in PowerShell, and will not automatically cast from a simple array.
            # This will look through all the properties of the request, find any that are simple arrays,
            # and convert them to a Generic.List of the appropriate type before creating the request object.
            $correctedRequest = @{}
            Write-Verbose "Processing RequestType $RequestType with RequestProperties $($RequestProperties | ConvertTo-Json -Compress)"
            foreach ($key in $RequestProperties.keys) {
                if ($RequestProperties[$key] -is 'System.Array') {
                    $type = $RequestProperties[$key][0].GetType().FullName
                    Write-Verbose "Converting $key to Generic.List of type $type"
                    $obj = New-Object System.Collections.Generic.List[$type]
                    foreach ($item in $RequestProperties[$key]) {
                        $obj.Add($item)
                    }
                    $correctedRequest[$key] = $obj
                } else {
                    Write-Verbose "Adding $key to Request as-is"
                    $correctedRequest[$key] = $RequestProperties[$key]
                }
            }
            Write-Verbose ("Generating new Request Google.Apis.Slides.v1.Data.$RequestType" + "Request")
            $request = New-Object ("Google.Apis.Slides.v1.Data.$RequestType" + "Request") -Property $correctedRequest
            Write-Verbose "Generating new Google.Apis.Slides.v1.Data.Request"
            New-Object Google.Apis.Slides.v1.Data.Request -Property @{$RequestType = $request}
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
