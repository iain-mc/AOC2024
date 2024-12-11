function Get-Total {
    param (
        [String] $Ops, 
        [Int[]] $Values
    )

    [bigint]$Total = 0
    [bigint]$L = $Values[0]
    for($i=0; $i -lt $Values.Count -1; $i++)
    {
        [Int]$R = $Values[$i+1]
        if($Ops[$i] -eq '0')
        {
            $Total = $L + $R
        }
        else 
        {
            $Total = $L * $R
        }

        $L = $Total
    }
    
    return $Total
}
function Test-Equation 
{
    param (
        [bigint] $Reult, 
        [Int[]] $Values
    )
    
    $NumOperators = $Values.Count -1 

    $Maps = [System.Collections.Generic.List[String]]::New()
    $Bits = [math]::floor([math]::Log2(([math]::pow(2, $NumOperators) -1))) +1
    0..([math]::pow(2, $NumOperators) -1) | %{$Maps += ([convert]::ToString($_,2)).PadLeft($Bits,'0')}

    foreach($Map in $Maps)
    {
        $Total = Get-Total -Ops $Map -Values $Values
        if($Total -eq $Reult)
        {
            return $True
        }
    }

    Return $False
}

$InputFile = Get-Content $PSScriptRoot\input.txt

$Total = 0
foreach($Line in $InputFile)
{
    $Res,$V = $Line -split ":"
    $V = ($V.Trim()).Split()
    if(Test-Equation -Reult $Res -Values $V)
    {
        $Total += [bigint]$Res
    }
}

$Total