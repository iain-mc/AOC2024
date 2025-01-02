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

class Robot {
    [Coordinate] $P 
    [Int] $VX
    [Int] $VY

    Robot([Coordinate] $P, [Int] $VX, [Int] $VY)
    {
        $This.P  = $P
        $This.VX = $VX
        $This.VY = $VY
    }

    [void]
    Step([Int]$Steps, [Int]$MX, [Int]$MY)
    {
        $DX = (($This.P).X + ($Steps * $This.VX)) % $MX
        $DY = (($This.P).Y + ($Steps * $This.VY)) % $MY
        if($DX -ge 0)
        {
            $This.P.X = $DX
        }
        else 
        {
            $This.P.X = $MX + $DX
        }

        if($DY -ge 0)
        {
            $This.P.Y = $DY
        }
        else 
        {
            $This.P.Y = $MY + $DY
        }
    }
    
    [int]
    getQuad([Int]$MX, [Int]$MY)
    {
        $QX = [Math]::Ceiling($MX/2) -1
        $QY = [Math]::Ceiling($MY/2) -1

        if($($This.P.X -gt $QX) -and $($This.P.Y -lt $QY))
        { return 1 }

        if($($This.P.X -gt $QX) -and $($This.P.Y -gt $QY))
        { return 2 }

        if($($This.P.X -lt $QX) -and $($This.P.Y -gt $QY))
        { return 3 }

        if($($This.P.X -lt $QX) -and $($This.P.Y -lt $QY))
        { return 4 }

        return 0
    }
}

function Print-Robots {
    param (
        [System.Collections.ArrayList] $Robots,
        [Int] $MX, 
        [Int] $MY
    )

    $Matrix = [System.Collections.Generic.List[Char[]]]::New()
    1..$MY | %{$Matrix.Add($('.' * $MX).ToCharArray())}

    foreach($Robot in $Robots)
    {
        $Matrix[$Robot.P.Y][$Robot.P.X] = '0'
    }

    $P = ""
    0..($Matrix.Count -1) | %{$P += (-join $Matrix[$_]); $P += [System.Environment]::NewLine}
    Write-Host $P    
}

$InputFile = Get-Content $PSScriptRoot\input.txt

$Robots = [System.Collections.ArrayList]::New()

foreach($Line in $InputFile)
{
    $Line -match "p=(\d+),(\d+) v=(.*),(.*)" | out-null
    $X = $Matches[1]
    $Y = $Matches[2]
    $VX = [int]::Parse($Matches[3])
    $VY = [int]::Parse($Matches[4])
    $P = [Coordinate]::New($X, $Y)
    $Robots.Add([Robot]::New($P, $VX, $VY)) | out-null
}

for($i = 0; $i -lt 100000; $i++)
{
    $Quads = @{}

    foreach($Robot in $Robots)
    {
        $Robot.Step(1, 101, 103)
        $Quad = $Robot.getQuad(101, 103)
        $Quads[$Quad] += 1
    }

    $Right = $Quads[1] + $Quads[2]
    $Left  = $Quads[3] + $Quads[4]

    $Total = $Robots.Count

    $quarter = $Total / 4

    if($(($Quads[1] / $quarter)*100) -lt 40) 
    {
        write-host "$('='*49)$i$('='*49)"
        Print-Robots -Robots $Robots -MX 101 -MY 103
        sleep 0.08
    }
}

return

$Quads = @{}

foreach($Robot in $Robots)
{
    $Robot.Step(100, 101, 103)
    $Quad = $Robot.getQuad(101, 103)
    $Quads[$Quad] += 1
}

$Quads[1] * $Quads[2] * $Quads[3] * $Quads[4]