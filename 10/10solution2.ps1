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

function Get-Neighbours
{
    param(
        [Parameter(Mandatory)]
        [Coordinate] $Start,
        [Parameter(Mandatory)]
        [System.Collections.Generic.List[Int[]]] $Matrix
    )

    $Neighbours = [System.Collections.Generic.List[Coordinate]]::New()

    $Box = @(
        @(-1, 0),
        @( 0,-1),
        @( 0, 1),
        @( 1, 0)
    )

    foreach($B in $Box)
    {
        $i = $B[0]
        $j = $B[1]
        if($($($Start.X + $i -ge 0) -and $($Start.X + $i -lt $Matrix[0].Count)) -and $($($Start.Y + $j -ge 0) -and $($Start.Y + $j -lt $Matrix.Count)))
        {
            $Neighbours.Add([Coordinate]::New($($Start.X + $i),$($Start.Y + $j)))
        }
    }

    return $Neighbours
}

function Get-TrailScore {
    param (
        [Parameter(Mandatory)]
        [Coordinate] $Start,
        [Parameter(Mandatory)]
        [System.Collections.Generic.List[Int[]]] $Matrix
    )

    #BaseCase
    $Total = 0
    if($Matrix[$Start.Y][$Start.X] -eq 9)
    {
        Return 1
    }
    else 
    {
        foreach($N in Get-Neighbours -Start $Start -Matrix $Matrix)
        {
            if($Matrix[$N.Y][$N.X] -eq ($Matrix[$Start.Y][$Start.X] +1))
            {
                $Total += Get-TrailScore -Start $N -Matrix $Matrix
            }
        }
        return $Total
    }
    return 0
}

$InputFile = Get-Content $PSScriptRoot\input.txt
$Matrix = [System.Collections.Generic.List[Int[]]]::New()
foreach($Line in $InputFile)
{
    $Row = [System.Collections.Generic.List[Int]]::New()
    $Line.ToCharArray() | %{$Row.Add([Int]::Parse($_))}
    $Matrix.Add($Row)
}

$SubTotal = 0 

for($x=0; $x -lt $Matrix[0].Count; $x++)
{
    for($y=0; $y -lt $Matrix.Count; $Y++)
    {
        if($Matrix[$y][$x] -eq 0)
        {
            $start = [Coordinate]::New($X, $Y)
            $SubTotal += Get-TrailScore -Start $start -Matrix $Matrix
        }
    }
}

$SubTotal