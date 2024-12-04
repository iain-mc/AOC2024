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

class xVector : System.IEquatable[System.Object]
{
    [Coordinate] $Start
    [Coordinate] $End

    xVector ([Coordinate] $Start, [Coordinate] $End)
    {
        $this.Start = $Start
        $this.End = $End
    }

    [System.Boolean]
    Equals ([object] $Other)
    {
        if ($($($this.Start -eq $Other.Start) -and $($this.End -eq $Other.End)) -or $($($this.Start -eq $Other.End) -and $($this.End -eq $Other.Start)))
        {
            return $true
        }
        return $false
    }
}

function Get-Word 
{
    param (
        [Parameter(Mandatory)]
        [System.Collections.Generic.List[Char[]]] $Matrix,
        [Parameter(Mandatory)]
        [Coordinate] $Start, 
        [Parameter(Mandatory)]
        [Coordinate] $End
    )
    
    $dX = $End.X - $Start.X
    $dY = $End.Y - $Start.Y

    $iX = ($dx -eq 0) ? @(0,0,0,0) : 0..$dX
    $iY = ($dY -eq 0) ? @(0,0,0,0) : 0..$dY 

    $Word = ""

    foreach($i in 0..3)
    {
        $a = $Start.Y + $iY[$i]
        $b = $Start.X + $iX[$i]
        $Word += $($Matrix[$a][$b])
    }

    return [string]$Word
}  

function Get-Endpoints 
{
    param(
        [Parameter(Mandatory)]
        [Coordinate] $Start,
        [Parameter(Mandatory)]
        [System.Collections.Generic.List[Char[]]] $Matrix
    )

    $Endpoints = [System.Collections.Generic.List[Coordinate]]::New()

    foreach($i in @(-3, 0, 3))
    {
        foreach($j in @(-3, 0, 3))
        {
            if($i -or $j)
            {
                if($($($Start.X + $i -ge 0) -and $($Start.X + $i -lt $Matrix[0].Count)) -and $($($Start.Y + $j -ge 0) -and $($Start.Y + $j -lt $Matrix.Count)))
                {
                    $Endpoints.Add([Coordinate]::New($($Start.X + $i),$($Start.Y + $j)))
                }
            }
        }
    }

    $Endpoints
}

$InputFile = Get-Content $PSScriptRoot\input.txt
$Matrix = [System.Collections.Generic.List[Char[]]]::New()
$InputFile | %{$Matrix.Add($_.ToCharArray())}

$words = [System.Collections.Generic.List[xVector]]::New()

$start = [Coordinate]::New(0,0)
$end = [Coordinate]::New(0,3)

for($y=0; $y -lt $Matrix.Count; $y++)
{
    for($X=0; $x -lt $Matrix[0].Count; $x++)
    {
        $Current = [Coordinate]::New($X, $Y)
        $endpoints = Get-Endpoints -Start $Current -Matrix $Matrix
        foreach($endpoint in $endpoints)
        {
            $word = Get-Word -Matrix $Matrix -Start $Current -End $endpoint
            
            if($word -match "XMAS|SAMX")
            {
                $words.Add([xVector]::New($Current, $endpoint))
            }
        }
    }
}

$($words.Count)/2