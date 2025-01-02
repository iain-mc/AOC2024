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

class Robot 
{
    [Coordinate] $P 
    [System.Collections.Generic.List[Char[]]] $M

    Robot([System.Collections.Generic.List[Char[]]] $M)
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
        $This.M = $M
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

        $Next = $This.M[$This.P.Y + $DY][$This.P.X + $DX]
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

        $NP = [Coordinate]::New($This.P.X + $DX, $This.P.Y + $DY)
        do {
            $NP.X += $DX
            $NP.Y += $DY
        } while ($This.M[$NP.Y][$NP.X] -eq 'O')

        if($This.M[$NP.Y][$NP.X] -eq '#')
        {
            return 
        }
        else 
        {
            $This.M[$NP.Y][$NP.X] = 'O'
            $This.M[$This.P.Y + $DY][$This.P.X + $DX] = '.'
            $This.P.X = $This.P.X + $DX
            $This.P.Y = $This.P.Y + $DY
        }
    }

    [void]
    Print()
    {
        $Print = ""
        $This.M[$This.P.Y][$This.P.X] = '@'
        0..(($This.M).Count -1) | %{$Print += (-join $This.M[$_]); $Print += [System.Environment]::NewLine}
        $This.M[$This.P.Y][$This.P.X] = '.'
        Write-Host "$Print" -NoNewline
    }

    [Int]
    GetGPS()
    {
        $Total = 0
        for($x=0; $x -lt $This.M[0].Count; $x++)
        {
            for($y=0; $y -lt $This.M.Count; $Y++)
            {
                if($This.M[$y][$x] -eq 'O')
                {
                    $Total += (100 * $y) + $x
                }
            }
        }
        return $Total
    }
}

$InputFile = Get-Content $PSScriptRoot\input.txt -Raw
$nl = [System.Environment]::NewLine

$Map,$Moves = $InputFile -split "$nl$nl"
$Matrix = [System.Collections.Generic.List[char[]]]::New()
$Map -split '\n' | %{$Matrix.Add(($_.trim()).ToCharArray())}

$Robot = [Robot]::New($Matrix)

foreach($Line in $Moves.Split())
{
    foreach($M in $Line.ToCharArray())
    {   
        $Robot.Move($M)
        $Robot.Print()
    }
}

$Robot.GetGPS()