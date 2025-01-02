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

class Box : System.IEquatable[System.Object]
{
    [Coordinate] $A 
    [Coordinate] $B

    Box([Coordinate] $A, [Coordinate] $B)
    {
        $This.A = $A
        $This.B = $B
    }

    [System.Boolean]
    Equals ([object] $Other)
    {
        if ($($Other.A -eq $this.A) -and $($Other.B -eq $this.B))
        {
            return $true
        }

        return $false
    }
}

class BoxList 
{
    [System.Collections.Generic.List[Box]] $Boxes
    [System.Collections.Generic.List[char[]]] $M

    BoxList()
    {
        $This.Boxes = [System.Collections.Generic.List[Box]]::New()
    }

    [void]
    Add([Box] $B)
    {
        $This.Boxes.Add($B)
    }

    [Box]
    GetBox([Coordinate] $P)
    {
        foreach($Box in $This.Boxes)
        {
            if($($Box.A -eq $P) -or $($Box.B -eq $P))
            {
                return $Box
            }
        }

        return $null
    }

    [Box]
    GetBox([Int] $X, [Int] $Y)
    {
        $P = [Coordinate]::New($X, $Y)
        return $This.GetBox($P)
    }
}

class Robot 
{
    [Coordinate] $P 
    [System.Collections.Generic.List[Char[]]] $M
    [BoxList] $BL

    Robot([System.Collections.Generic.List[Char[]]] $M, [BoxList] $BL)
    {
        for($x=0; $x -lt $M[0].Count; $x++)
        {
            for($y=0; $y -lt $M.Count; $Y++)
            {
                if($M[$y][$x] -eq '@')
                {
                    $This.P = [Coordinate]::New($x, $y)
                    $M[$y][$x] = '.'
                }
            }
        }
        $This.M  = $M
        $This.BL = $BL
    }

    [void]
    Move([Char] $D)
    {
        $DX = 0; $DY = 0

        switch ($D) {
            '^' { $DX =  0; $DY = -1 }
            'v' { $DX =  0; $DY =  1 }
            '<' { $DX = -1; $DY =  0 }
            '>' { $DX =  1; $DY =  0 }
        }

        $NP = [Coordinate]::New(($This.P.X + $DX), $($This.P.Y + $DY))

        if($Box = $This.BL.GetBox($NP))
        {
            if($THIs.CanMoveBox($Box, $D))
            {            
                $This.MoveBox($Box, $D)
                $This.P.X += $DX
                $This.P.Y += $DY
            }

            Return 
        }

        $Next = $This.M[$NP.Y][$NP.X]
        if($Next -eq '.')
        {
            $This.P.X += $DX
            $This.P.Y += $DY
            Return 
        }
    
        if($Next -eq '#')
        {
            Return 
        }
    }

    [void]
    Print()
    {
        $Print = ""
        $This.M[$This.P.Y][$This.P.X] = '@'
        for($y=0; $y -lt $This.M.Count; $y++)
        {
            for($x=0; $x -lt $This.M[$y].Count; $x++)
            {
                if($This.BL.GetBox($x, $y))
                {
                    $Print += "[]"
                    $x++
                }
                else 
                {
                    $Print += $This.M[$y][$x]
                }
            }
            $Print += [System.Environment]::NewLine
        }

        $This.M[$This.P.Y][$This.P.X] = '.'
        Write-Host "$Print" -NoNewline
    }

    [Int]
    GetGPS()
    {
        $Total = 0
        foreach($B in $This.BL.Boxes)
        {
            $Total += ($B.A.Y * 100) + $B.A.X
        }
        return $Total
    }

    [bool]
    CanMoveBox([Box] $B, [string] $D)
    {
        $DX, $DY, $DXA, $DXB = 0

        switch ($D) {
            '^' { $DX =  0; $DY = -1 }
            'v' { $DX =  0; $DY =  1 }
            '<' { $DX = -1; $DY =  0 } 
            '>' { $DX =  2; $DY =  0 }
        }

        if($D -match '<|>')
        {
           if($BX = $This.BL.GetBox($($B.A.X + $DX), $($B.A.Y)))
           {
                return $This.CanMoveBox($BX, $D)
           }

           if($This.M[$B.A.Y][$B.A.X + $DX] -eq '.')
           {
                return $true
           }

           return $false
        }

        if($D -match '\^|v')
        {
            $BA = [Coordinate]::New($B.A.X, $($B.A.Y + $DY))
            $BB = [Coordinate]::New($B.B.X, $($B.B.Y + $DY))

            if($This.M[$BA.Y][$BA.X] -eq '#')
            {
                return $false
            }

            if($This.M[$BB.Y][$BB.X] -eq '#')
            {
                return $false
            }

            $Boxes = [System.Collections.Generic.List[Box]]::New()

            $Boxes.Add($This.BL.GetBox($BA))
            $Boxes.Add($This.BL.GetBox($BB))

            $Boxes.RemoveAll({$args[0] -eq $Null})# = $Boxes | ?{$Null -ne $_} 

            if($Boxes.Count -eq 0)
            {
                if($($this.M[$BA.Y][$BA.X] -eq '.') -and $($this.M[$BB.Y][$BB.X] -eq '.'))
                {
                    return $true
                }
                else {
                    return $false
                }
            }

            if($Boxes.Count -eq 1)
            {
                $Box = $Boxes[0]
                return $This.CanMoveBox($Box, $D) 
            }

            if($Boxes[0] -eq $Boxes[1])
            {
                $Boxes.RemoveAt(1)
            }

            if($Boxes.Count -eq 1)
            {
                $Box = $Boxes[0]
                return $This.CanMoveBox($Box, $D) 
            }

            if($Boxes.Count -eq 2)
            {
                return ($($This.CanMoveBox($Boxes[0], $D))) -and $($This.CanMoveBox($Boxes[1], $D))
            }

            return $False
        }

        return $false
    }

    [Void]
    MoveBox([Box] $Box, [Char] $D)
    {
        if(-not $This.CanMoveBox($Box, $D))
        {
            return 
        }
        $DX, $DY = 0

        switch ($D) {
            '^' { $DX =  0; $DY = -1 }
            'v' { $DX =  0; $DY =  1 }
            '<' { $DX = -1; $DY =  0 } 
            '>' { $DX =  2; $DY =  0 }
        }

        #HORIZONTAL 
        if($D -match '<|>')
        {            
            $Boxes = [System.Collections.Generic.List[Box]]::New()
            $B = $Box
            $Boxes.Add($B)
            while($B = $This.BL.GetBox($B.A.X + $DX, $B.A.Y))
            {
                $Boxes.Add($B)
            }

            foreach($B in $Boxes)
            {
                if($D -eq '>')
                {
                    $B.A.X += 1
                    $B.B.X += 1
                }
                else 
                {
                    $B.A.X += -1
                    $B.B.X += -1
                }
            }
        }

        #VERTICAL 
        if($D -match '\^|v')
        {
            $BA = [Coordinate]::New($Box.A.X, $($Box.A.Y + $DY))
            $BB = [Coordinate]::New($Box.B.X, $($Box.B.Y + $DY))

            $Boxes = [System.Collections.Generic.List[Box]]::New()

            $Boxes.Add($This.BL.GetBox($BA))
            $Boxes.Add($This.BL.GetBox($BB))

            $Boxes.RemoveAll({$args[0] -eq $Null}) # $Boxes = $Boxes | ?{$Null -ne $_} 

            if($Boxes.Count -eq 2)
            {
                if($Boxes[0] -eq $Boxes[1])
                {
                    $Boxes.RemoveAt(1)
                }
            }

            $Box.A.Y += $DY
            $Box.B.Y += $DY

            foreach($Box in $Boxes)
            {
                $This.MoveBox($Box, $D)
            }
        }
    }
}

function Print-Matrix {
    param (
        [System.Collections.Generic.List[char[]]] $M
    )
 
    $Print = ""
    0..(($M).Count -1) | %{$Print += (-join $M[$_]); $Print += [System.Environment]::NewLine}
    Write-Host "$Print" -NoNewline

}
 
$InputFile = Get-Content $PSScriptRoot\test.txt -Raw
$nl = [System.Environment]::NewLine

$Map,$Moves = $InputFile -split "$nl$nl"
$Matrix = [System.Collections.Generic.List[char[]]]::New()

#Expand the Matrix
$Map = $Map -split '\n'
for($y=0; $y -lt $Map.Count; $y++)
{
    $Line = $Map[$y].Trim()
    $Line = $Line.ToCharArray()
    [string]$MX = ""
    for($x=0; $x -lt $Line.Count; $x++)
    {
        switch ($Line[$x]) {
            '.' { $MX += ".." }
            'O' { $MX += "[]" }
            '#' { $MX += "##" }
            '@' { $MX += "@." } 
        }
    }
    $Matrix.Add($MX)
}

Print-Matrix $Matrix

$BL = [BoxList]::New()

#Populate the BoxList
for($y=0; $y -lt $Matrix.Count; $y++)
{
    for($x=0; $x -lt $Matrix[$y].Count; $x++)
    {
        if($Matrix[$y][$x] -eq '[')
        {
            $A = [Coordinate]::New($x, $y)
            $B = [Coordinate]::New($x +1, $y)
            $Box = [Box]::New($A, $B)
            $BL.Add($Box)
            $Matrix[$y][$x] = '.'
            $Matrix[$y][$x+1] = '.'
        }
    }
}

$Robot = [Robot]::New($Matrix, $BL)

$Robot.GetGPS()

$i = 0 
foreach($Line in $Moves.Split())
{
    foreach($M in $Line.ToCharArray())
    {   
        $Robot.Move($M)
        $Robot.Print()
    }
}

$Robot.Print()
$Robot.GetGPS()