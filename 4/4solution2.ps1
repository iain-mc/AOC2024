class Coordinate : System.IEquatable[System.Object]
{
    [Int] $X
    [Int] $Y

    Coordinate ([Int] $X, [Int] $Y)
    {
        $this.X = $X
        $this.Y = $Y
    }

    [System.Boolean]
    Equals ([object] $Other)
    {
        if ($($Other.X -eq $this.X) -and $($Other.Y -eq $this.Y))
        {
            return $true
        }

        return $false
    }
}

function Test-Xmas {
    param (
        [Coordinate] $S,
        [Parameter(Mandatory)]
        [System.Collections.Generic.List[Char[]]] $M
    )

    $d1 = "$($M[$S.Y +1][$S.X -1])$($M[$S.Y][$S.X])$($M[$S.Y -1][$S.X +1])"    
    $d2 = "$($M[$S.Y -1][$S.X -1])$($M[$S.Y][$S.X])$($M[$S.Y +1][$S.X +1])"    

    return $($($d1 -match "mas|sam") -and $($d2 -match "mas|sam"))
}

$InputFile = Get-Content $PSScriptRoot\input.txt
$Matrix = [System.Collections.Generic.List[Char[]]]::New()
$InputFile | %{$Matrix.Add($_.ToCharArray())}

$Total = 0 

for($y=1; $y -lt $Matrix.Count -1; $y++)
{
    for($X=1; $x -lt $Matrix[0].Count -1; $x++)
    {
        $Start = [Coordinate]::New($x, $y)
        if(Test-Xmas -M $Matrix -S $Start)
        {
            $Total++
        }
    }
}

$Total 