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

$Quads = @{}

foreach($Robot in $Robots)
{
    $Robot.Step(100, 101, 103)
    $Quad = $Robot.getQuad(101, 103)
    $Quads[$Quad] += 1
}

$Quads[1] * $Quads[2] * $Quads[3] * $Quads[4]