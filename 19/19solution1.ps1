$InputFile = Get-Content $PSScriptRoot\input.txt -Raw
$nl = [System.Environment]::NewLine

$Towels,$Combos = $InputFile -split "$nl$nl"

$Towels = $Towels -split ',' | %{$_.Trim()}

$Towels

$regex = "^("

foreach($T in $Towels)
{
    $regex += "$T|"
}

$regex = $regex -replace ".$"

$regex += ")*$"

$Total = 0 
foreach($c in $Combos -split '\n')
{
    if($c.trim() -match $regex)
    {
        $Total++
    }
}

$Total