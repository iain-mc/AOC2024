$InputFile = Get-Content $PSScriptRoot\input.txt

$InstructionBlocks = @()

#Get leading instructions
$Mt = [regex]::Matches($InputFile, '^(.*?)(?=do\(\))')
$Mt | %{$InstructionBlocks += $_.Value}

#Get instructions between do and don't blocks
$Mt = [regex]::Matches($InputFile, "(?<=do\(\))(.*?)(?=don't\(\))")
$Mt | %{$InstructionBlocks += $_.Value}
 
$Total = 0 

foreach($Instruction in $InstructionBlocks)
{
    $Mt = [regex]::Matches($Instruction, 'mul\(\d+,\d+\)')

    foreach($M in $Mt)
    {    
        $M.Value -match "mul\((\d+),(\d+)\)"
        $A = [int]$Matches[1]
        $B = [int]$Matches[2]
        $total += ($A * $B)
    }
}

$Total