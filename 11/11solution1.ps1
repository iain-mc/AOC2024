$InputFile = Get-Content $PSScriptRoot\input.txt

$Stones = [System.Collections.Generic.LinkedList[string]]::New()

foreach($S in $InputFile -split ' ')
{
    $Stones.Add($S)
}
 
foreach($n in 1..75)
{    
    $SD = Get-Date
    for($Stone = $Stones.First; $Stone -ne $null; $Stone=$Stone.Next)   
    {

        $StoneString = $Stone.Value
        if($StoneString -eq '0')
        {
            $Stone.Value = 1
        }
        elseif (!($StoneString.length % 2)) 
        {
            $Half = $StoneString.length / 2
            $L = [bigint]($StoneString.substring(0, $Half))
            $R = [bigint]($StoneString.substring($Half, $Half))
            $Stone.Value = "$L"
            $Stones.AddAfter($Stone, "$R") | Out-Null
            $Stone = $Stone.Next
        }
        else
        {
            $Value = [System.Numerics.BigInteger]::Parse($StoneString) * 2024
            $Stone.Value = $Value
        }
    }
    $ED = Get-Date
    Write-Progress "LINE: $N - $(($ED.Subtract($SD)).TotalMinutes) minutes - $($Stones.Count) Stones"
}

$Stones.Count