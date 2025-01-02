function Get-Combo {
    param (
        [Int] $Combo
    )

    switch ($Combo) 
    {
        0 { return 0 }
        1 { return 1 }
        2 { return 2 }
        3 { return 3 }
        4 { return $Global:A }
        5 { return $Global:B }
        6 { return $Global:C }
    }
}

$InputFile = Get-Content $PSScriptRoot\test.txt -Raw
$nl = [System.Environment]::NewLine

$Registers,$P = $InputFile -split "$nl$nl"

$matches = [regex]::Matches($Registers, "Register A: (?<A>\d+)\r\nRegister B: (?<B>\d+)\r\nRegister C: (?<C>\d+)")
$Global:A = [Int]::Parse($matches[0].Groups['A'].Value)
$Global:B = [Int]::Parse($matches[0].Groups['B'].Value)
$Global:C = [Int]::Parse($matches[0].Groups['C'].Value)

$Program = [System.Collections.Generic.List[Int]]::New()
$out     = [System.Collections.Generic.List[Int]]::New()


($P -split ' ')[1] -split ',' | %{$Program.Add($([Int]::Parse($_)))}

$Pointer = 0 
while($Pointer -lt $Program.Count)
{
    $Opcode = $Program[$Pointer]
    write-host "[$Opcode] A: $A  B: $B C: $C P: $Pointer"
    switch ($Opcode) 
    {
        0 { $Global:A = $([Math]::truncate(($Global:A / $([Math]::Pow(2,$(Get-Combo $Program[$Pointer + 1])))))); $Pointer = $Pointer + 2}
        1 { $Global:B = $($Global:B -bxor $Program[$Pointer + 1]); $Pointer = $Pointer + 2}
        2 { $Global:B = $($(Get-Combo $Program[$Pointer + 1]) % 8); $Pointer = $Pointer + 2 }
        3 { $($Global:A -eq 0) ? $($Pointer = $Pointer + 2) : $($Pointer = $Program[$Pointer + 1])}
        4 { $Global:B = $($Global:B -bxor $Global:C);$Pointer = $Pointer + 2 }
        5 { $Out.Add($($(Get-Combo $Program[$Pointer + 1]) % 8 ));$Pointer = $Pointer + 2 }
        6 { $Global:B = $([Math]::truncate(($Global:A / $([Math]::Pow(2,$(Get-Combo $Program[$Pointer + 1])))))); $Pointer = $Pointer + 2}
        7 { $Global:C = $([Math]::truncate(($Global:A / $([Math]::Pow(2,$(Get-Combo $Program[$Pointer + 1])))))); $Pointer = $Pointer + 2}
    }
}