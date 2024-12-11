$Global:Cache = @{}
function Iterate-Number 
{
    param (
        [bigint] $Num, 
        [Int] $N
    )

    if($N -eq 0){ return [bigint]1 } 

    if($Global:Cache.ContainsKey("$Num-$N")){ return [bigint]$Global:Cache["$Num-$N"] }

    [bigint]$Total = 0 
    if($Num -eq 0)
    {
        $Global:Cache["$Num-$N"] = [bigint](iterate-Number -Num 1 -N ($N -1))
        $Total += $Global:Cache["$Num-$N"]
    }
    elseif (!((($Num).ToString()).length % 2)) 
    {
        $StoneString = $Num.ToString()
        $Half = $StoneString.length / 2
        [bigint]$L = [bigint]($StoneString.substring(0, $Half))
        [bigint]$R = [bigint]($StoneString.substring($Half, $Half))
        $Global:Cache["$Num-$N"] = [bigint]($(Iterate-Number -Num $L -N ($N -1)) + $(Iterate-Number -Num $R -N ($N -1)))
        $Total += $Global:Cache["$Num-$N"]
    }
    else
    {
        $Global:Cache["$Num-$N"] = [bigint](Iterate-Number -Num $($Num * 2024) -N ($N - 1))
        $Total += $Global:Cache["$Num-$N"]
    }
    
    return $Total
}

$InputFile = Get-Content $PSScriptRoot\input.txt

$Stones = [System.Collections.Generic.LinkedList[bigint]]::New()

foreach($S in $InputFile -split ' ')
{
    $Stones.Add([Int]::Parse($S))
}
$Global:Cache = @{}

[bigint]$Total = 0 
$i = 0 
foreach($Stone in $Stones)
{
    $i++
    Write-Progress "PROCESSING STONE: $i"
    [bigint]$StoneTotal = Iterate-Number -Num $Stone -N 75
    $Total += $StoneTotal
}

$Total