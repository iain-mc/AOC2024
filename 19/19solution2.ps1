function Get-TTotal {
    param (
        [String] $T,
        [String[]] $TS
    )

    $Total = 0 

    $Parts = [System.Collections.Generic.HashSet[String]]::New()

    for($i=0; $i -lt $T.Length; $i++)
    {
        for($j=1; $j -lt ($T.Length - $i); $j++)
        {
            if($TS.Contains($T.Substring($i, $j)))
            {
                $Parts.Add($T.Substring($i, $j))
            }
        }
    }

    return $Parts.Count

    # $i = 1 
    # while($($i -le $T.Length) -and $($TS.Contains($T.Substring(0, $i))))
    # {
    #     #if($TS.Contains($T.Substring(0, $i))){ $Total++ }
    #     $Total++ 
    #     $i++
    # }

    # if($Total -eq 0)
    # {
    #     return 0 
    # }
 
    # if($Tail = $T.Substring($i -1))
    # {
    #     $TailToal = $(Get-TTotal $Tail $TS)
    #     if($TailToal)
    #     {
    #         return $Total * $TailToal
    #     }
    #     else 
    #     {
    #         return 0 
    #     }
    # }

    # return $Total
}


$InputFile = Get-Content $PSScriptRoot\test.txt -Raw
$nl = [System.Environment]::NewLine

$Towels,$Combos = $InputFile -split "$nl$nl"

$Towels = $Towels -split ',' | %{$_.Trim()}

Get-TTotal "gbbr" $Towels

return 
$TTotal = 0 

foreach($C in $Combos -split '\n')
{
    $SubTotal = Get-TTotal $($C.Trim()) $Towels
    write-host "$($C.trim()) - $SubTotal"
    $TTotal += $SubTotal

}

$TTotal