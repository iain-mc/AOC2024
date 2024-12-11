function Get-Disk {
    param (
        [String] $InputString
    )

    $Disk = [System.Collections.Generic.List[bigint]]::New()
    $ID = 1

    for($i=0; $i -lt $InputString.Length; $i++)
    {
        $Block = [System.Int32]::Parse($InputString[$i])

        if($i % 2) #Free Space Block 
        {
            if($Block)
            {
                1..$Block | %{$Disk.Add(0)}
            }
        }
        else #File Block 
        {
            if($Block)
            {
                1..$Block | %{$Disk.Add($ID)}
            }
            $ID++
        }
    }

    $Disk
}

function Sort-DiskString 
{
    param (
        [System.Collections.Generic.List[bigint]] $Disk
    )
    
    $j = $Disk.IndexOf(0)
    for($i=$Disk.Count -1; $i -gt $j; $i--)
    {
        if($Disk[$i])
        {
            $Disk[$j], $Disk[$i] = $Disk[$i], $Disk[$j]
            $j = $Disk.IndexOf(0, $j + 1)
        }

    }

    return $Disk
}

function Get-DiskChecksum {
    param (
        [System.Collections.Generic.List[bigint]] $Disk
    )
    
    [bigint]$Total = 0
    for($i=0; $i -lt $Disk.Count; $i++)
    {
        if($Disk[$i] -eq 0)
        {
            break
        }
        $ID = [System.Int32]::Parse($Disk[$i])
        $Total += $i * ($ID -1)
    }
    return $Total
}

$InputFile = Get-Content $PSScriptRoot\input.txt
[System.Collections.Generic.List[bigint]]$Disk = Get-Disk $InputFile
$s = Sort-DiskString $Disk
Get-DiskChecksum $s

