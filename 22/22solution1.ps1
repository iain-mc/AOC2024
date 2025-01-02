function Get-SecretNumber {
    param (
        [Int] $Secret,
        [Int] $Iterations
    )

    foreach($i in 1..$Iterations)
    {
        $Secret = (($Secret * 64) -bxor $Secret) % 16777216
        $Secret = ([System.Math]::Floor(($Secret / 32)) -bxor $Secret) % 16777216
        $Secret = (($Secret * 2048) -bxor $Secret) % 16777216
    }
    
    return $Secret

}

$InputFile = Get-Content $PSScriptRoot\input.txt

$Total = 0
foreach($Line in $InputFile)
{
    $Total += Get-SecretNumber $Line 2000
}

$Total