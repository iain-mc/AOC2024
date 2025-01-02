$InputFile = Get-Content $PSScriptRoot\input.txt -Raw
$nl = [System.Environment]::NewLine

$Keys  = [System.Collections.Generic.List[Int[]]]::New()
$Locks = [System.Collections.Generic.List[Int[]]]::New()

function Check-Lock
 {
    param (
        [System.Collections.Generic.List[Int]] $Key,
        [System.Collections.Generic.List[Int]] $Lock
    )
    
    foreach($i in 0..4)
    {
        if(($Key[$i] + $Lock[$i]) -gt 7)
        {
            return $false
        }
    }

    return $true

}

foreach($Block in $InputFile -split "$nl$nl")
{
    $BlockArr = [System.Collections.Generic.List[char[]]]::New()
    $Block -split '\n' | %{$BlockArr.add(($_.trim()).ToCharArray())}

    $Heights = [System.Collections.Generic.List[Int]]::New()
    foreach($i in 0..4)
    {
        $Heights.Add(($BlockArr | %{$_[$i]} | ?{$_ -eq '#'} | measure).count)
    }

    if((-join $BlockArr[0]) -eq "#####")
    {
        $Locks.Add($Heights)
    }
    else 
    {
        $Keys.Add($Heights)
    }
}

$Total = 0 
foreach($Key in $Keys)
{
    foreach($Lock in $Locks)
    {
        if(Check-Lock -Key $Key -Lock $Lock)
        {
            $Total ++
        }
    }
}

$Total 