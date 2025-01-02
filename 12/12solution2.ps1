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
        [System.Collections.Generic.List[char[]]] $Matrix,
        [ValidateSet("All", "Cross", "Diag")]
        [String] $Mode,
        [switch] $IncOffMap
    )

    $Neighbours = [System.Collections.Generic.List[Coordinate]]::New()

    switch ($Mode) {
        "All" {         
            $Box = @(
                @( 0,  1),
                @( 0, -1),
                @( 1,  0),
                @( 1,  1),
                @( 1, -1),
                @( -1, 0),
                @( -1, 1),
                @( -1,-1)
            ) 
        }
        "Cross" {  
            $Box = @(
                @(-1, 0),
                @( 0,-1),
                @( 0, 1),
                @( 1, 0)
            )
        }
        "Diag" { 
            $Box = @(
                @( 1, -1),
                @( 1,  1),
                @(-1,  1),
                @(-1, -1)
            )
         }
    }

    foreach($B in $Box)
    {
        $i = $B[0]
        $j = $B[1]
        if(-not $IncOffMap)
        {
            if($($($Start.X + $i -ge 0) -and $($Start.X + $i -lt $Matrix[0].Count)) -and $($($Start.Y + $j -ge 0) -and $($Start.Y + $j -lt $Matrix.Count)))
            {
                $Neighbours.Add([Coordinate]::New($($Start.X + $i),$($Start.Y + $j)))
            }
        }
        else 
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

    $Neighbours = Get-Neighbours -Start $Start -Matrix $Matrix -Mode "Cross"
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

function Measure-Corners {
    param (
        [Coordinate] $P,
        [System.Collections.Generic.List[Object]] $Area, 
        [System.Collections.Generic.List[char[]]] $M
    )
    
    $DS = Get-Neighbours -Start $P -Matrix $M -Mode "Diag" -IncOffMap
    $Total = 0 
    
    #####
    #D A#
    # P #
    #C B#
    #####

    foreach($D in $DS)
    {
        #CASE-A
        if($($D.X -eq $P.X + 1) -and $($D.Y -eq $P.Y -1))
        {
            if($($M[$P.Y][$P.X] -ne  $M[$D.Y][$D.X]) -and $($M[$P.Y][$P.X] -eq $M[$D.Y + 1][$D.X]) -and $($M[$P.Y][$P.X] -eq $M[$D.Y][$D.X -1]))
            {
                $Total++
            }
            if($($M[$P.Y][$P.X] -ne $M[$D.Y + 1][$D.X]) -and $($M[$P.Y][$P.X] -ne $M[$D.Y][$D.X -1]))
            {
                $Total++
            }
        }

        #CASE-B
        if($($D.X -eq $P.X + 1) -and $($D.Y -eq $P.Y + 1))
        {
            if($($M[$P.Y][$P.X] -ne  $M[$D.Y][$D.X]) -and $($M[$P.Y][$P.X] -eq $M[$D.Y - 1][$D.X]) -and $($M[$P.Y][$P.X] -eq $M[$D.Y][$D.X -1]))
            {
                $Total++
            }
            if($($M[$P.Y][$P.X] -ne $M[$D.Y - 1][$D.X]) -and $($M[$P.Y][$P.X] -ne $M[$D.Y][$D.X -1]))
            {
                $Total++
            }
        }

        #CASE-C
        if($($D.X -eq $P.X - 1) -and $($D.Y -eq $P.Y + 1))
        {
            if($($M[$P.Y][$P.X] -ne  $M[$D.Y][$D.X]) -and $($M[$P.Y][$P.X] -eq $M[$D.Y - 1][$D.X]) -and $($M[$P.Y][$P.X] -eq $M[$D.Y][$D.X + 1]))
            {
                $Total++
            }
            if($($M[$P.Y][$P.X] -ne $M[$D.Y - 1][$D.X]) -and $($M[$P.Y][$P.X] -ne $M[$D.Y][$D.X + 1]))
            {
                $Total++
            }
        }

        #CASE-D
        if($($D.X -eq $P.X - 1) -and $($D.Y -eq $P.Y - 1))
        {
            if($($M[$P.Y][$P.X] -ne  $M[$D.Y][$D.X]) -and $($M[$P.Y][$P.X] -eq $M[$D.Y + 1][$D.X]) -and $($M[$P.Y][$P.X] -eq $M[$D.Y][$D.X + 1]))
            {
                $Total++
            }
            if($($M[$P.Y][$P.X] -ne $M[$D.Y + 1][$D.X]) -and $($M[$P.Y][$P.X] -ne $M[$D.Y][$D.X + 1]))
            {
                $Total++
            }
        }
    }

    return $Total
}

$InputFile = Get-Content $PSScriptRoot\input.txt
$H = $InputFile.Count
$W = $InputFile[0].Length + 2
$Matrix = [System.Collections.Generic.List[char[]]]::New()

$Matrix.Add($('0'*$W).ToCharArray())
$InputFile | %{$Line = "0$($_)0"; $Matrix.Add($Line.ToCharArray())}
$Matrix.Add($('0'*$W).ToCharArray())


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
    if($K -like '0-*') {continue}
    $Area = $Global:Areas[$K].count
    $Corners = 0 
    foreach($P in $Global:Areas[$K])
    {
        $C = Measure-Corners -P $P -M $Matrix -Area $Global:Areas[$K]
        $Corners += $C
    }
   $Total += ($Area * $Corners)
}

$Total