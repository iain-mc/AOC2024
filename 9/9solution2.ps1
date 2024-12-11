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

    $Moved = [System.Collections.Generic.HashSet[Int]]::New()
    $tr = $Disk.Count
    $M = $Disk.Count -1
    While($M -gt $0)
    {
        $perc = ($M / $tr) * 100
        write-Progress -Activity "Processing M: $M, $perc%"

        if(!$Disk[$M])
        {
            $M--
            continue
        }

        #Don't moved files twice 
        if(!($Moved.Add($Disk[$M])))
        {
            $M--
            continue
        }

        $N = $M
        #Get file block
        while(($Disk[$N] -eq $Disk[$M]) -and $N -ge 0)
        {
            $N--
        }

        #Find the length of it 
        $FileLen = $M - $N
        $FileType = $Disk[$M]

        for($i=0; $i -lt $Disk.Count; $i++)
        {
            #Start of free block
            $k = $Disk.IndexOf(0, $i)
            $l = $k 

            #Find End of free block
            while($Disk[$l] -eq 0){$l ++; if(($l - $k) -ge $FileLen){break}}
            
            #Length of free block 
            $f = $l - $k

            #If it's big enough, replace
            if((($l -$k) -ge $FileLen) -and $l -lt $M)
            {
                $k..($K + $FileLen -1) | %{$Disk[$_] = $FileType}
                ($N+1)..$M | %{$Disk[$_] = 0}
                break
            }
        }
 
        $M = $N 
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
            continue
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