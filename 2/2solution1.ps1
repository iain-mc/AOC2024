function Test-Saftey {
    param (
        [Parameter(Mandatory)]
        [Int[]] $Levels
        )

    $Asc = $false
    $Dsc = $false

    if($Levels[0] -eq $Levels[1])
    {
        return $false
    }    

    if($Levels[0] -gt $Levels[1])
    {
        $Asc = $true
    }  

    if($Levels[0] -lt $Levels[1])
    {
        $Dsc = $true
    }  

    if($Asc)
    {
        for($i=0; $i -lt ($Levels.Count -1) ; $i++)
        {
            if($Levels[$i] -lt $Levels[$i + 1])
            {
                return $false
            }
    
            if([System.Math]::Abs($Levels[$i] - $Levels[$i + 1])  -notin 1..3)
            {
                return $false
            }  
        }

        return $true
    }

    if($Dsc)
    {
        for($i=0; $i -lt ($Levels.Count -1) ; $i++)
        {
            if($Levels[$i] -gt $Levels[$i + 1])
            {
                return $false
            }
    
            if([System.Math]::Abs($Levels[$i] - $Levels[$i + 1])  -notin 1..3)
            {
                return $false
            }  
        }

        return $true
    }
    

}

$inputFile = Get-Content $PSScriptRoot\input.txt

$Total = 0

foreach($Line in $inputFile)
{
    $Report = $Line -split '\s'

    if (Test-Saftey -Levels $Report) 
    {
        $Total++
    }
}

$Total