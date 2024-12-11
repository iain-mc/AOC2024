function Get-Ternary 
{
    param (
        [Int] $N,
        [Int] $Pad
    )

    if($N -eq 0)
    {
        return "0".PadLeft($Pad,'0')
    } 
    
    $Tern = ""

    while($N)
    {
        $R = $N % 3
        $N = [MATH]::Floor($N / 3)
        $Tern += $R
    }

    $Result = $Tern.ToCharArray()

    [array]::Reverse($Result)
    return (-join $Result).PadLeft($Pad,'0')
}

function Get-TernaryPermutations {
    param (
        [Int] $N
    )
    
    $i = [System.Math]::pow(3,$N) -1
    $p = [System.Collections.Generic.List[String]]::New()

    foreach($j in 0..$i)
    {
        $t = Get-Ternary $j $N
        $p.Add($t)
    }

    return $p
}
function Get-Total {
    param (
        [String] $Ops, 
        [Int[]] $Values
    )

    [bigint]$Total = 0
    [bigint]$L = $Values[0]
    for($i=0; $i -lt $Values.Count -1; $i++)
    {
        [Int]$R = $Values[$i+1]
        switch ($Ops[$i] ) {
            0 { $Total = $L + $R }
            1 { $Total = $L * $R }
            2 { $Total = [bigint]("$L" + "$R") }
        }
        
        $L = $Total
    }
    
    return $Total
}
function Test-Equation 
{
    param (
        [bigint] $Reult, 
        [Int[]] $Values
    )
    
    $NumOperators = $Values.Count -1 

    $Maps = Get-TernaryPermutations -N $NumOperators

    foreach($Map in $Maps)
    {
        $Total = Get-Total -Ops $Map -Values $Values
        if($Total -eq $Reult)
        {
            return $True
        }
    }

    Return $False
}

$InputFile = Get-Content $PSScriptRoot\input.txt

[bigint]$Total = 0
$D = 0
$L = $InputFile.Count
foreach($Line in $InputFile)
{
    $D++
    write-Progress -Activity "[Line: $($D)] BRUTE FORCE IN PROGRESS" -Status "$(($D / $L)*100)%"
    $Res,$V = $Line -split ":"
    $V = ($V.Trim()).Split()
    if(Test-Equation -Reult $Res -Values $V)
    {
        $Total += [bigint]$Res
    }
}

$Total