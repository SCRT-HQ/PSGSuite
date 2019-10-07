function Write-InlineProgress {
    <#
        .SYNOPSIS
            Display an inline progress bar in the PowerShell console.
        .DESCRIPTION
            Display an inline progress bar in the PowerShell console.
        .NOTES
            Be sure to always call the function with either the -Stop or -Completed switch after the progress bar is finished.
            Be sure to NOT output anything while the progress bar is updating - or it WILL "break"!
            This function will not work when run in PowerShell ISE.

            Author: Øyvind Kallstad
            Date: 28.04.2016
            Version: 1.0
        .LINK
            https://communary.wordpress.com/
    #>
    [CmdletBinding(DefaultParameterSetName = 'normal')]
    param (
        # Describe the activity being performed.
        [Parameter(Position = 0, ParameterSetName = 'normal')]
        [Parameter(ParameterSetName = 'completed')]
        [string] $Activity,

        # Minimum padding for the activity text. When set to 0 (default) the size of the activity text
        # is automatically adjusted based on the window width.
        [Parameter(ParameterSetName = 'normal')]
        [Parameter(ParameterSetName = 'completed')]
        [ValidateRange(0,[int]::MaxValue)]
        [int] $ActivityPadding = 0,

        # Display seconds remaining.
        [Parameter(ParameterSetName = 'normal')]
        [Parameter(ParameterSetName = 'completed')]
        [ValidateRange(0,[int]::MaxValue)]
        [int] $SecondsRemaining,

        # Display seconds elapsed.
        [Parameter(ParameterSetName = 'normal')]
        [Parameter(ParameterSetName = 'completed')]
        [ValidateRange(0,[int]::MaxValue)]
        [int] $SecondsElapsed,

        # Define the percent complete value for the progress bar.
        [Parameter(ParameterSetName = 'normal')]
        [ValidateRange(0,100)]
        [int] $PercentComplete,

        # Display the percent complete.
        # Note! If the window width is below 40 the percent value will not be displayed.
        [Parameter(ParameterSetName = 'normal')]
        [Parameter(ParameterSetName = 'completed')]
        [switch] $ShowPercent = $true,

        # Stop without any update to the progress bar.
        [Parameter(ParameterSetName = 'stop')]
        [switch] $Stop,

        # Output last progress result.
        [Parameter(ParameterSetName = 'stop')]
        [switch] $OutputLastProgress,

        # Stop the progress bar with a final update.
        [Parameter(ParameterSetName = 'completed')]
        [switch] $Completed,

        # Customize the progress character.
        [Parameter(ParameterSetName = 'normal')]
        [Parameter(ParameterSetName = 'completed')]
        [ValidateLength(1,1)]
        [ValidateNotNull()]
        [string] $ProgressCharacter = '#',

        # Customize the progress fill character.
        [Parameter(ParameterSetName = 'normal')]
        [Parameter(ParameterSetName = 'completed')]
        [ValidateLength(1,1)]
        [ValidateNotNull()]
        [string] $ProgressFillCharacter = '#',

        # Customize the fill character.
        [Parameter(ParameterSetName = 'normal')]
        [Parameter(ParameterSetName = 'completed')]
        [ValidateLength(1,1)]
        [ValidateNotNull()]
        [string] $ProgressFill = '.',

        # Customize the bracket before the progress bar.
        [Parameter(ParameterSetName = 'normal')]
        [Parameter(ParameterSetName = 'completed')]
        [ValidateLength(0,1)]
        [string] $BarBracketStart = '[',

        # Customize the bracket after the progress bar.
        [Parameter(ParameterSetName = 'normal')]
        [Parameter(ParameterSetName = 'completed')]
        [ValidateLength(0,1)]
        [string] $BarBracketEnd = ']',

        # Use Write-Output instead of Console.Write
        # If you want to support transcripts, you need to use this parameter on the last update of the
        # progress bar so that it will be written to the transcript file. The same goes for any error handling if
        # you want the last status of the progress bar to be written to the transcript.
        [Parameter(ParameterSetName = 'normal')]
        [Parameter(ParameterSetName = 'completed')]
        [switch] $UseWriteOutput
    )

    # this function only works when run from the console
    if ($Host.Name -notlike '*ISE*') {
        if ($Stop) {
            if ($OutputLastProgress) {
                Write-Host (($script:lastProgressString).ToString()) -NoNewline
            }
            else {
                Remove-Variable -Name 'lastProgressString' -Scope 'Script' -ErrorAction SilentlyContinue
                [console]::WriteLine()
            }
            try {
                [System.Console]::CursorVisible = $true
            }
            catch {
                if ($Error[0].Exception.Message -eq 'Exception setting "CursorVisible": "The handle is invalid."') {
                    $Global:Error.Remove($Global:Error[0])
                }
            }
        }
        else {
            if ($Completed) {
                $PercentComplete = 100
                if ($PSBoundParameters.ContainsKey('SecondsRemaining')) {
                    # have to force it to 0 or it will display the last value before it finished
                    $SecondsRemaining = 0
                }
            }

            # if the buffer if full, we need to resize it to make sure that the progress bar don't break
            if (($host.UI.RawUI.CursorPosition.y + 1) -ge ($host.UI.RawUI.BufferSize.Height)) {
                $size = New-Object System.Management.Automation.Host.Size(($host.UI.RawUI.BufferSize.Width), (($host.UI.RawUI.BufferSize.Height + 1000)))
                $host.UI.RawUI.BufferSize = $size
            }

            $cursorPosition = $host.UI.RawUI.CursorPosition
            #$cursorPositionY = $host.UI.RawUI.CursorPosition.Y
            try {
                [System.Console]::CursorVisible = $false
            }
            catch {
                if ($Error[0].Exception.Message -eq 'Exception setting "CursorVisible": "The handle is invalid."') {
                    $Global:Error.Remove($Global:Error[0])
                }
            }
            $windowWidth = [console]::WindowWidth

            # if screen is very small, don't display the percent
            if ($windowWidth -le 40) {$ShowPercent = $false}

            # calculate the size of the activity part of the output string
            if ($ActivityPadding -eq 0) {
                $activityPart = [math]::Floor($windowWidth / 4)
            }
            else {
                $activityPart = $ActivityPadding
            }

            # if activity string is longer than the allocated part length, truncate it
            if ($Activity.Length -gt $activityPart) {
                $Activity = Out-TruncatedString -String $Activity -Length $activityPart
            }

            $progressString = New-Object System.Text.StringBuilder -ArgumentList $windowWidth

            # add activity text to the progress string
            [void]$progressString.Append("$($Activity.PadRight($ActivityPart, ' ')) ")

            # add seconds elapsed to the progress string
            if ($PSBoundParameters.ContainsKey('SecondsElapsed')) {
                [void]$progressString.Append([timespan]::FromSeconds($SecondsElapsed).ToString() + ' ')
            }

            # add seconds remaining to the progress string
            if ($PSBoundParameters.ContainsKey('SecondsRemaining')) {
                [void]$progressString.Append([timespan]::FromSeconds($SecondsRemaining).ToString() + ' ')
            }

            # add the start bracket for the progress bar to the progress string
            [void]$progressString.Append($BarBracketStart)

            # calculate the width of the progress bar
            # the 5 is to account for the space of the percent information
            if ($ShowPercent) {
                $progressBarWidth = $windowWidth - (($progressString.Length) + 5)
            }
            else {
                $progressBarWidth = $windowWidth - ($progressString.Length) + 1
            }

            # add one to the progress bar width if no end bracket is used
            if (-not ($BarBracketEnd)) {
                $progressBarWidth++
            }

            # calculate the bar character percentage and how much of the bar is filled and how much is not filled
            $barCharacterInPercent = ($progressBarWidth - 2) / 100
            $barProgressed = [math]::Floor($PercentComplete * $barCharacterInPercent)
            $barNotProgressed = ($progressBarWidth - 2) - $barProgressed

            # add the progress bar to progress string
            if ($barProgressed -gt 0) {
                if ($barNotProgressed -gt 0) {
                    [void]$progressString.Append(($ProgressFillCharacter * ($barProgressed - 1)))
                    [void]$progressString.Append($ProgressCharacter)
                }
                else {
                    [void]$progressString.Append(($ProgressFillCharacter * $barProgressed))
                }
            }
            [void]$progressString.Append("$($ProgressFill * $barNotProgressed)$($BarBracketEnd)")

            # add the percent complete to the progress string
            if ($ShowPercent) {
                [void]$progressString.Append(" $($PercentComplete.ToString().PadLeft(3, ' '))% ")
            }

            # if not already present, create a string builder to hold the last progress string
            if (-not ($script:lastProgressString)) {
                $script:lastProgressString = New-Object System.Text.StringBuilder($windowWidth)
            }

            # only update the progress string if it's different from the last (optimization)
            if (-not($script:lastProgressString.ToString() -eq $progressString.ToString())) {
                if ($UseWriteOutput) {
                    Write-Output ($progressString.ToString())
                }
                else {
                    [console]::Write(($progressString.ToString()))
                }

                $host.UI.RawUI.CursorPosition = $cursorPosition
                #$host.UI.RawUI.CursorPosition = 0, $cursorPositionY
                [void]$script:lastProgressString.Clear()
                [void]$script:lastProgressString.Append($progressString.ToString())
            }

            if ($Completed) {
                # do some clean-up and jump to the next line
                Remove-Variable -Name 'lastProgressString' -Scope 'Script' -ErrorAction SilentlyContinue
                try {
                    [System.Console]::CursorVisible = $true
                }
                catch {
                    if ($Error[0].Exception.Message -eq 'Exception setting "CursorVisible": "The handle is invalid."') {
                        $Global:Error.Remove($Global:Error[0])
                    }
                }
                [console]::WriteLine()
            }
        }
    }
    else {
        Write-Warning 'This function is not compatible with PowerShell ISE.'
    }
}
