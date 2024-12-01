$inputFile = Get-Content $PSScriptRoot\test.txt

$r =  [System.Collections.Generic.List[Int64]]::New() 
$l =  [System.Collections.Generic.List[Int64]]::New()  

$inputFile -split "\n" | %{$x, $y = $_ -split '\s+'; $l.Add($x); $r.Add($y)}

$r = $r | Sort-Object
$l = $l | Sort-Object

$t = 0

0..999 | %{$t += $([math]::Abs($r[$_] - $l[$_]))}

$t