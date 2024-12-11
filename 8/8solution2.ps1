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

function Get-AntiNodes {
    param (
        [Coordinate] $A,
        [Coordinate] $B,
        [System.Collections.Generic.List[Char[]]] $M
    )

    $dX = $A.X - $B.X
    $dY = $A.Y - $B.Y

    $ANodes = [System.Collections.ArrayList]::New()
    $ANodes.Add($A)

    $A1 = [Coordinate]::New($A.X, $A.Y)
    $A2 = [Coordinate]::New($A.X, $A.Y)

    do {
        $A1X = $A1.X + $dX
        $A2X = $A2.X - $dX
    
        $A1Y = $A1.Y + $dY
        $A2Y = $A2.Y - $dY

        $A1 = [Coordinate]::New($A1X, $A1Y)
        $A2 = [Coordinate]::New($A2X, $A2Y)
        $ANodes.Add($A1)
        $ANodes.Add($A2)

    } while ( 
        (($A1.Y -lt $M.Count) -and $($A1.X -lt $M[0].Count) -and $($A1.X -ge 0) -and $($A1.Y -ge 0))`
        -or`
        (($A2.Y -lt $M.Count) -and $($A2.X -lt $M[0].Count) -and $($A2.X -ge 0) -and $($A2.Y -ge 0))
    )

    return $ANodes
}


$InputFile = Get-Content $PSScriptRoot\input.txt
$Matrix = [System.Collections.Generic.List[Char[]]]::New()
$InputFile | %{$Matrix.Add($_.ToCharArray())}

$Points = @{}

for($x=0; $x -lt $Matrix[0].Count; $x++)
{
    for($y=0; $y -lt $Matrix.Count; $Y++)
    {
        if($Matrix[$y][$x] -ne '.')
        {
            if(!$Points.ContainsKey($Matrix[$y][$x]))
            {
                $Points[$Matrix[$y][$x]] = [System.Collections.ArrayList]::New()
            }
            $Points[$Matrix[$y][$x]].Add([Coordinate]::New($x, $y)) | Out-Null
        }
    }
}

$AntiNodes = New-Object System.Collections.Generic.HashSet[String]

foreach($k in $Points.Keys)
{

    $PL = $Points[$k]
    foreach($P1 in $PL)
    {
        foreach($P2 in $PL)
        {
            if($P1 -eq $P2)
            {
                continue
            }

            foreach($AntiNode in  Get-AntiNodes $P1 $P2 $Matrix)
            {
                if(($AntiNode.Y -lt $Matrix.Count) -and $($AntiNode.X -lt $Matrix[0].Count) -and $($AntiNode.X -ge 0) -and $($AntiNode.Y -ge 0))
                {
                    $AntiNodes.Add("$($AntiNode.X),$($AntiNode.Y)")
                }
            }
        }
    }
}

$AntiNodes.Count