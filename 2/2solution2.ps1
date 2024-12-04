function get-ListPermutations
{
    param (
        [Parameter(Mandatory)]
        [System.Collections.Generic.List[Int]] $list  
    )
    
    $Permutations = [System.Collections.Generic.List[Int[]]]::New()
    $Permutations.Add($list)

    for($i=0; $i -lt $list.Count; $i++)
    {
        $Permutation = [System.Collections.Generic.List[Int]]::New()
        $list | %{$Permutation.Add($_)}
        $Permutation.RemoveAt($i)
        $Permutations.Add($Permutation)
    }

    return $Permutations
}

function Test-AscRange
{
    param (
        [Parameter(Mandatory)]
        [Int] $X,
        [Parameter(Mandatory)]
        [Int] $Y
     )  

     return ($X -lt $Y) -and ([math]::Abs($X -$Y) -in 1..3)
}

function Test-DscRange
{
    param (
        [Parameter(Mandatory)]
        [Int] $X,
        [Parameter(Mandatory)]
        [Int] $Y
     )  

     return ($X -gt $Y) -and ([math]::Abs($X -$Y) -in 1..3)
}

function Test-AscSaftey {
    param (
        [Parameter(Mandatory)]
        [Int[]] $Levels
    )    
        
    for($i=0; $i -lt $Levels.Count -1; $i++)
    {
        $current = $Levels[$i]
        $next    = $Levels[$i+1]
        
        if(!$(Test-AscRange $current $next))
        {
            return $false
        }
    }
    return $true
}

function Test-DscSaftey {
    param (
        [Parameter(Mandatory)]
        [Int[]] $Levels
    )    

    for($i=0; $i -lt $Levels.Count -1; $i++)
    {
        $current = $Levels[$i]
        $next    = $Levels[$i+1]
        
        if(!$(Test-DscRange $current $next))
        {
            return $false
        }
    }
    return $true
}

$inputFile = Get-Content $PSScriptRoot\input.txt

$Total = 0

foreach($Line in $inputFile)
{
    $Report = $Line -split '\s'

    $ReportPermutations = get-ListPermutations $Report

    foreach($perm in $ReportPermutations)
    {
        if($(Test-AscSaftey $perm) -or $(Test-DscSaftey $perm))
        {
            $total++
            break
        }
    }

}

$Total