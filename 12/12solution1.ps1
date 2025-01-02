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
        [System.Collections.Generic.List[char[]]] $Matrix
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


$Global:Done  = [System.Collections.Generic.HashSet[string]]::New()
$Global:Areas = @{}

function Get-Area {
    param (
        [Char] $Type,
        [string] $ID,
        [Coordinate] $Start, 
        [System.Collections.Generic.List[char[]]] $Matrix
    )

    $Neighbours = Get-Neighbours -Start $Start -Matrix $Matrix
    $Neighbours = $Neighbours | ?{-not $Global:Done.Contains("$($_.X),$($_.Y)")} | ?{$Matrix[$_.Y][$_.X] -eq $Type}

    if(-not $Global:Areas.ContainsKey($ID))
    {
        $Global:Areas[$ID] = [System.Collections.Generic.List[Object]]::New()
    }

    if(-not $Global:Done.Contains("$($Start.X),$($Start.Y)"))
    {
        $Global:Areas[$ID].Add($Start)
    }
    
    $Global:Done.Add("$($Start.X),$($Start.Y)") | out-null

    #Base Case
    if($Neighbours.Count -eq 0)
    {
        return 
    }

    foreach($Neighbour in $Neighbours)
    {
        Get-Area -Type $Type -ID $ID -Start $Neighbour -Matrix $Matrix
    }
}

function Get-Perim 
{
    param (
        [System.Collections.Generic.List[Coordinate]] $Area,
        [System.Collections.Generic.List[char[]]] $Matrix
    )
    
    $Perim = 0 
    foreach($P in $Area)
    {
        $Neighbours = Get-Neighbours -Start $P -Matrix $Matrix
        $Perim += $(4 - $Neighbours.count)
        $Neighbours = $Neighbours | ?{$Matrix[$P.Y][$P.X] -ne $Matrix[$_.Y][$_.X]}
        $Perim += $Neighbours.Count
    }

    return $Perim
}

$InputFile = Get-Content $PSScriptRoot\input.txt
$Matrix = [System.Collections.Generic.List[char[]]]::New()
$InputFile | %{$Matrix.Add($_.ToCharArray())}

$i=0
$m = 0
$ms = $Matrix[0].Count * $Matrix.Count
for($x=0; $x -lt $Matrix[0].Count; $x++)
{
    for($y=0; $y -lt $Matrix.Count; $Y++)
    {
        Write-Progress "BRUCE FORCING THIS ONE [$x, $y]: $(($m/$ms) * 100)"
        $m++
        $ID = "$($Matrix[$y][$x])-$i"
        $p = [Coordinate]::New($x, $y)
        if($Global:Done.Contains("$x,$y")){ continue }
        Get-Area -Type $($Matrix[$y][$x]) -ID $ID -Start $P -Matrix $Matrix
        $i++
    }
}

$Total = 0 
foreach($K in $Global:Areas.Keys)
{
    $Area = $Global:Areas[$K].count
    $Perim = get-perim $Global:Areas[$k] $Matrix
    $Total += ($Area * $Perim)
#    Write-Host "ID: $K COUNT: $($Global:Areas[$K].count)"
}

$Total