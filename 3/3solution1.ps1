$InputFile = Get-Content $PSScriptRoot\input.txt

$Mt = [regex]::Matches($inputFile, 'mul\(\d+,\d+\)')

$Total = 0 

foreach($M in $Mt)
{
    $M.Value -match "mul\((\d+),(\d+)\)"
    $A = [int]$Matches[1]
    $B = [int]$Matches[2]
    $total += ($A * $B)
}

$Total 