class Mech
{
    [string]$Mech = ""
    [string]$Variant = ""
    [int]$PointValue = 0
}

class Lance
{
    [System.Collections.Generic.List[Mech]]$Mechs
    [int]$LanceSize = 0
    [int]$PointValue = 0

    Lance()
    {
        $this.Mechs = New-Object System.Collections.Generic.List[Mech]
    }

    AddMech ([Mech]$newMech)
    {
        $this.LanceSize++
        $this.PointValue += $newMech.PointValue
        $this.Mechs.Add($newMech)
        
    }

    [string]ToString()
    {
        $csvLine = ""
        $csvLine += $this.PointValue
        $csvLine += ","
        $csvLine += $this.LanceSize
        $csvLine += ","
        foreach($m in $this.Mechs)
        {
            $csvLine += $m.Mech
            $csvLine += ","
            $csvLine += $m.Variant
            $csvLine += ","
        }
        
        return $csvLine
    }
}

$sourceData = Import-Csv .\testInput.csv 
$sourceMechs = new-object System.Collections.Generic.List[Mech]
$Lances = new-object System.Collections.Generic.List[Lance]

foreach($m in $sourceData)
{
    $newMech = New-Object Mech
    $newMech.Mech = $m.Mech
    $newMech.Variant = $m.Variant
    $newMech.PointValue = $m.PointValue

    $sourceMechs.Add($newMech)
}

foreach($m in $sourceMechs)
{   
    foreach($m2 in $sourceMechs)
    {
        $lance = New-Object Lance
        $lance.AddMech($m)
        $lance.AddMech($m2)

        $isDupe = $false
        foreach($l in $Lances)
        {
            if($l.Mechs.Contains($m) -and $l.Mechs.Contains($m2)) 
            { 
                $isDupe = $true
                break;
            }            
        }
        
        if($isDupe -eq $false) { $Lances.Add($lance) }
    }    
}

foreach($m in $sourceMechs)
{    
    foreach($m2 in $sourceMechs)
    {
        foreach($m3 in $sourceMechs)
        {
            $lance = New-Object Lance
            $lance.AddMech($m)
            $lance.AddMech($m2)
            $lance.AddMech($m3)
            $isDupe = $false
            foreach($l in $Lances)
            {
                if($l.Mechs.Contains($m) -and $l.Mechs.Contains($m2) -and $l.Mechs.Contains($m3)) 
                { 
                    $isDupe = $true
                    break;
                }            
            }
            
            if($isDupe -eq $false) { $Lances.Add($lance) }
            
        }
    }    
}

foreach($m in $sourceMechs)
{    
    foreach($m2 in $sourceMechs)
    {
        foreach($m3 in $sourceMechs)
        {
            foreach($m4 in $sourceMechs)
            {
                $lance = New-Object Lance
                $lance.AddMech($m)
                $lance.AddMech($m2)
                $lance.AddMech($m3)
                $lance.AddMech($m4)
                $isDupe = $false
                foreach($l in $Lances)
                {
                    if($l.Mechs.Contains($m) -and $l.Mechs.Contains($m2) -and $l.Mechs.Contains($m3) -and $l.Mechs.Contains($m4)) 
                    { 
                        $isDupe = $true
                        break;
                    }            
                }
            
                if($isDupe -eq $false) { $Lances.Add($lance) }
            }
        }
    }    
}

foreach($m in $sourceMechs)
{    
    foreach($m2 in $sourceMechs)
    {
        foreach($m3 in $sourceMechs)
        {
            foreach($m4 in $sourceMechs)
            {
                foreach($m5 in $sourceMechs)
                {
                    $lance = New-Object Lance
                    $lance.AddMech($m)
                    $lance.AddMech($m2)
                    $lance.AddMech($m3)
                    $lance.AddMech($m4)
                    $lance.AddMech($m5)
                    $isDupe = $false
                    foreach($l in $Lances)
                    {
                        if($l.Mechs.Contains($m) -and $l.Mechs.Contains($m2) -and $l.Mechs.Contains($m3) -and $l.Mechs.Contains($m4) -and $l.Mechs.Contains($m5)) 
                        { 
                            $isDupe = $true
                            break;
                        }            
                    }
            
                    if($isDupe -eq $false) { $Lances.Add($lance) }
                }
            }
        }
    }    
}
$Lances.Count
$Lances | % {$_.ToString()} | Out-File .\Lances.csv 

