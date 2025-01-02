class Gate 
{
    [ref] $IN1
    [ref] $IN2
    [string] $Name
    [bool] $Evaluated 
    [bool] $Value
    [String] $Op

    Gate([ref] $IN1, [ref] $IN2, [string] $Name, [bool] $Evaluated, [bool] $Value, [string] $Op)
    {
        $This.IN1 = $IN1
        $This.IN2 = $IN2
        $This.Name = $Name
        $This.Evaluated = $Evaluated
        $This.Value = $Value
        $This.Op = $Op
    }

    [bool]
    Evaluate()
    {
        if($This.Evaluated)
        {
            return $This.Value
        }

        $This.Evaluated = $True

        switch ($This.Op) 
        {
            "AND" { return ($This.Value = ($This.IN1.Value).Evaluate() -and ($This.IN2.Value).Evaluate())}
            "OR"  { return ($This.Value = ($This.IN1.Value).Evaluate() -or  ($This.IN2.Value).Evaluate())}
            "XOR" { return ($This.Value = ($This.IN1.Value).Evaluate() -xor ($This.IN2.Value).Evaluate())}
        }

        return $true
    }

}

$InputFile = Get-Content $PSScriptRoot\input.txt -Raw
$nl = [System.Environment]::NewLine
$Init,$Rules = $InputFile -split "$nl$nl"

$Gates = @{}

foreach($Rule in $Rules -split '\n')
{
    $Rule.trim() -match "(?<IN1>.*) (?<OP>.*) (?<IN2>.*) -> (?<OUT>.*)"
    $IN1 = $Matches['IN1'] 
    $IN2 = $Matches['IN2'] 
    $OUT = $Matches['OUT'] 
    $OP  = $Matches['OP'] 

    if(-not $Gates.ContainsKey($OUT))
    {
        $Gates[$OUT] = [Gate]::New($null, $null, $OUT, $false, $null, $OP)
    }

    if(-not $Gates.ContainsKey($IN1))
    {
        $Gates[$IN1] = [Gate]::New($null, $null, $IN1, $false, $null, $null)
    }

    if(-not $Gates.ContainsKey($IN2))
    {
        $Gates[$IN2] = [Gate]::New($null, $null, $IN2, $false, $null, $null)
    }

    $Gates[$OUT].IN1       = [ref]$Gates[$IN1]
    $Gates[$OUT].IN2       = [ref]$Gates[$IN2]
    $Gates[$OUT].OP        = $OP
    $Gates[$OUT].Value     = $null
    $Gates[$OUT].Evaluated = $false
}

foreach($I in $Init -split "\n")
{
    $I.trim() -match "(?<IN>...): (?<VAL>.)"
    if($Matches['VAL'] -eq '0')
    {
        $Gates[$Matches['IN']].Value = $false
    }
    else 
    {
        $Gates[$Matches['IN']].Value = $true
    }

    $Gates[$Matches['IN']].Evaluated = $true
}

$s=""; $Gates.Keys | ?{$_ -like 'z*'} | sort -Descending | %{$Gates[$_].evaluate()} | %{$_ ? ($s += '1') : ($s += '0')}

[Convert]::ToInt64($s,2)