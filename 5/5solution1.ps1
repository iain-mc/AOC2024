function Test-Update {
    param (
        [Int[]] $Update,
        [System.Collections.Hashtable] $RuleMap
    )
    
    #BaseCase
    if($Update.Count -eq 1)
    {
        return $True
    }

    $Head = $Update[0]
    $Tail = $Update[1..$($Update.Count -1)]

    foreach($t in $Tail)
    {

        if($RuleMap.Contains($Head))
        {
            if($RuleMap[$Head].Contains($T))
            {
                return $False
            }
        }
    }

    return Test-Update -Update $Tail -RuleMap $RuleMap

}

$InputFile = Get-Content $PSScriptRoot\input.txt -Raw
$nl = [System.Environment]::NewLine

$Rules,$Updates = $InputFile -split "$nl$nl"

$RuleMap = @{}

foreach($Rule in $Rules -split "$nl")
{
    [Int]$L,[Int]$R = $Rule -split "\|"
    if(!$RuleMap[$L])
    {
        $RuleMap[$L] = [System.Collections.Generic.List[Int]]::New()
    }

    $RuleMap[$L].Add($R)
}

$total = 0
foreach($u in $Updates -split '\n')
{
    [int[]] $Update = $u -split ','

    [array]::Reverse($Update)

    if(Test-Update -Update $Update -RuleMap $RuleMap)
    {
        $Middle = $Update[$([Math]::Floor(($Update.Count / 2)))]
        $Total += $Middle
    }
}
 $total