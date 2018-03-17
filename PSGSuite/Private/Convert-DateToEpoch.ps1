function Convert-DateToEpoch {
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true)]
        [datetime]
        $Date
    )
    Begin {
        $UnixEpoch = [timezone]::CurrentTimeZone.ToLocalTime([datetime]'1/1/1970')
    }
    Process {
        $result = (("$(($Date - $UnixEpoch).TotalMilliseconds)" -split "\.") -split "\,")[0]
    }
    End {
        return $result
    }
}