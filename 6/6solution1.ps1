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

class Guard {
    [System.Collections.Generic.List[Char[]]] $Map
    [Coordinate] $Current
    [Coordinate] $Original
    [Int] $Heading

    #HEADING#
    #   0   #
    #   N   # 
    #3 W E 1# 
    #   S   #
    #   2   #
    #########
    
    Guard ([System.Collections.Generic.List[Char[]]] $Map)
    {
        $This.Map = $Map
        $This.Heading = 0

        for($x=0; $x -lt $Map[0].Count; $x++)
        {
            for($y=0; $y -lt $Map.Count; $Y++)
            {
                if($Map[$y][$x] -eq '^')
                {
                    $this.Current  = [Coordinate]::New($x, $y)
                    $this.Original = [Coordinate]::New($x, $y)
                }
            }
        }
    }

    [Coordinate]
    LookAhead()
    {
        switch ($This.Heading) {
            0 { return [Coordinate]::New($($This.Current.X),     $($This.Current.Y -1)) }
            1 { return [Coordinate]::New($($This.Current.X + 1), $($This.Current.Y))}
            2 { return [Coordinate]::New($($This.Current.X),     $($This.Current.Y +1)) }
            3 { return [Coordinate]::New($($This.Current.X -1),  $($This.Current.Y)) }
        }
        return $This.Current
    }

    [void]
    Step()
    {   
        $LookAhead = $This.LookAhead()

        #if it's not in the map, don't do the rest of the checks 
        if(!($($LookAhead.Y -lt $This.Map.Count) -and $($LookAhead.X -lt $This.Map[0].Count) -and $($LookAhead.X -ge 0) -and $($LookAhead.Y -ge 0)))
        {
            $This.Current = $LookAhead 
            return 
        }

        if($This.Map[$LookAhead.Y][$LookAhead.X] -match '\.|\^')
        {
            $This.Current = $LookAhead
        }
        else
        {
            $This.heading = ($This.heading + 1) % 4
            $This.Current = $This.LookAhead()
        }
    }

    [Int]
    Patrol()
    {
        $Visited = New-Object System.Collections.Generic.HashSet[String]
        do 
        {
            $Visited.Add("$($This.Current.X),$($This.Current.Y)")
            $This.Step()
        } while ($($This.Current.Y -lt $This.Map.Count) -and $($This.Current.X -lt $This.Map[0].Count) -and $($This.Current.X -ge 0) -and $($This.Current.Y -ge 0))
        return $Visited.Count
    }
}

$InputFile = Get-Content $PSScriptRoot\input.txt
$Map = [System.Collections.Generic.List[Char[]]]::New()
$InputFile | %{$Map.Add($_.ToCharArray())}

$Guard = [Guard]::New($Map)
$Guard.Patrol()