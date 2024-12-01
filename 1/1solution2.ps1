$inputFile = Get-Content $PSScriptRoot\test.txt

$r =  [System.Collections.Generic.List[Int64]]::New() 
$l =  [System.Collections.Generic.List[Int64]]::New()  

$inputFile -split "\n" | %{$x, $y = $_ -split '\s+'; $l.Add($x); $r.Add($y)}

$t = 0 

foreach($i in $l)
{
    $c = 0
    foreach($j in $r)
    {
        if ($i -eq $j) 
        {
            $c++
        }
    }
    
    $t += $($i * $c)
}

$t