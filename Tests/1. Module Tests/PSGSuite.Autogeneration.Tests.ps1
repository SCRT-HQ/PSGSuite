$ModuleName = 'PSGSuite'
$ProjectRoot = Resolve-Path "$PSScriptRoot\..\.." | Select-Object -ExpandProperty Path
$SourceModulePath = Resolve-Path "$ProjectRoot\$ModuleName" | Select-Object -ExpandProperty Path
$TargetModulePath = Get-ChildItem "$ProjectRoot\BuildOutput\$($ModuleName)" | Sort-Object { [Version]$_.Name } | Select-Object -Last 1 -ExpandProperty FullName

Describe "Function AutoGeneration Assumptions" {
    # If these tests fail, then most likely something has changed with the Google API .Net libraries
    # The Auto generation is built on certain assumptions about the .Net libraries and their objects
    # If those libraries or objects change, the assumptions may no longer be true
    # The auto generation code will need to be updated, as well as these tests updated, to handle these changes
    Import-Module "$TargetModulePath\$($ModuleName).psd1" -Force -ErrorAction SilentlyContinue

    $genTargets = @(
        'Google.Apis.Sheets.v4.Data.Request'
        'Google.Apis.Docs.v1.Data.Request'
        'Google.Apis.Slides.v1.Data.Request'
    )
    $script:alltypes = @()
    $script:allDefs = @()
    $script:allPropNames = @()
    function decode-type {
        param($type)
        # Write-Warning $type
        $obj = New-Object $type
        $allSubTypeProps = $obj | Get-Member -MemberType Property | Where-Object {$_.Name -ne 'ETag'}
        foreach ($subTypeprop in $allSubTypeProps) {
            # Write-Warning $definition
            $paramType = $subTypeprop.Definition.Split(' ',2)[0]
            if ($paramType -match '\[.*\]') {
                $typeSplit = ($paramType | Select-String -Pattern '([\w|\.]+)\[(.*)\]' -AllMatches).Matches.Groups[1..2].Value
                if ($typeSplit[0] -match 'IList') {
                    $fullType = $typeSplit[1]
                }
                elseif ($typeSplit[0] -match 'IDictionary') {
                    $fullType = $typeSplit[1].Split(',')[1]
                }
                else {
                    $fullType = $paramType
                }
            }
            else {
                $fullType = $paramType
            }
            if ($script:allDefs -notcontains $paramType) {
                $script:allDefs += $paramType
            }
            if ($script:allPropNames -notcontains $subTypeprop.Name) {
                $script:allPropNames += $subTypeprop.Name
            }
            if ($script:alltypes -notcontains $fullType) {
                $script:alltypes += $fullType
                if ($fullType -match '^Google\.') {
                    decode-type $fullType
                }
            }
        }
    }
    foreach ($BaseType in $genTargets) {
        $req = New-Object $BaseType
        $allReqProps = ($req | Get-Member -MemberType Property | Where-Object {$_.Name -ne 'ETag'})
        foreach ($reqprop in $allReqProps) {
            $fullType = $reqprop.Definition.Split(' ',2)[0]
            if ($script:alltypes -notcontains $fullType) {
                $script:alltypes += $fullType
            }
            if ($script:allDefs -notcontains $fullType) {
                $script:allDefs += $fullType
            }
            if ($script:allPropNames -notcontains $reqprop.Name) {
                $script:allPropNames += $reqprop.Name
            }
            decode-type -type $fullType
        }
    }

    $allLists = $script:allDefs | Where-Object {$_ -match 'IList'}
    $allDicts = $script:allDefs | Where-Object {$_ -match 'IDictionary'}
    $allNullable = $script:allDefs | Where-Object {$_ -match '^System\.Nullable'}
    $allbare = $script:allDefs | Where-Object {$_ -notmatch '\[.*\]'}

    $allBracketMatch = $script:allDefs | Where-Object {$_ -match '\[.*\]'}
    $allElseBracket = $allBracketMatch | Where-Object {($_ -notin $allLists) -and ($_ -notin $allDicts) -and ($_ -notin $allNullable)}

    $dictsKeysNotStrings = $allDicts | Where-Object {$_ -notmatch 'IDictionary\[string,'}

    $allListsNobrackets = $allLists | Where-Object {$_ -notmatch '\[.*\]'}
    $allDictsNobrackets = $allDicts | Where-Object {$_ -notmatch '\[.*\]'}
    $bareList = $script:allDefs | Where-Object {($_ -notmatch '\[.*\]') -and ($_ -match 'IList')}
    $bareDict = $script:allDefs | Where-Object {($_ -notmatch '\[.*\]') -and ($_ -match 'IDictionary')}
    $allElse = $script:allDefs | Where-Object {($_ -notin $allLists) -and ($_ -notin $allDicts) -and ($_ -notin $allbare) -and ($_ -notin $allNullable)}
    $requests = $script:allPropNames | Where-Object {$_ -eq 'Requests'}

    It "Assumption: Only Lists, Dictionaries, and Nullable variables will match '\[.*\]'" {
        $allElseBracket | Should -BeNullOrEmpty -Because "Generation code assumes only these types will have brackets"
    }
    It "Assumption: All Dictionaries will have [strings] as keys" {
        $dictsKeysNotStrings | Should -BeNullOrEmpty -Because "Generation code does no further inspection on keys of dictionaries"
    }
    It "Assumption: All Parameters will be one of List, Dictionary, Nullable, or a 'bare' object" {
        $allelse | Should -BeNullOrEmpty -Because "While bare ond nullable objects require no special handling, Lists and Dictionaries do. New types may require additional special handling during generation"
    }
    It "Assumption: No Parameter will have the name 'Requests'" {
        $requests | Should -BeNullOrEmpty -Because "The auto-generated functions add a Requests parameter for use on the pipeline, so an object having a Requests property would cause invalid code to be generated"
    }
    It "Assumption: All Lists will match '\[.*\]'" {
        $allListsNobrackets | Should -BeNullOrEmpty
        $bareList | Should -BeNullOrEmpty -Because "Generation code only detects and handles Lists when it detects brackets"
    }
    It "Assumption: All Dictionaries will match '\[.*\]'" {
        $allDictsNobrackets | Should -BeNullOrEmpty
        $bareDict | Should -BeNullOrEmpty -Because "Generation code only detects and handles Dictionaries when it detects brackets"
    }
}
