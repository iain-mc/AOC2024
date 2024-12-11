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
        [Coordinate] $B
    )
 
    $dX = $A.X - $B.X
    $dY = $A.Y - $B.Y

    $aX = $A.X + $dX
    $bX = $B.X - $dX

    $aY = $A.Y + $dY
    $bY = $B.Y - $dY

    return @($([Coordinate]::New($aX, $aY)), $([Coordinate]::New($bX, $bY)))
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

            foreach($AntiNode in  Get-AntiNodes $P1 $P2)
            {
                if(($AntiNode.Y -lt $Matrix.Count) -and $($AntiNode.X -lt $Matrix[0].Count) -and $($AntiNode.X -ge 0) -and $($AntiNode.Y -ge 0))
                {
                    $AntiNodes.Add("$($AntiNode.X),$($AntiNode.Y)")
                }
            }
        }
    }
}
