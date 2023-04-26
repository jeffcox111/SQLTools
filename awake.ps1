param($sleep = 60) # seconds

Clear-Host

$WShell = New-Object -com "Wscript.Shell"

Write-Host "Start time:" $(Get-Date -Format "dddd MM/dd HH:mm (K)")

while ( $true )
{
    $WShell.sendkeys("{SCROLLLOCK}")

    Start-Sleep -Milliseconds 200

    $WShell.sendkeys("{SCROLLLOCK}")
    
    for($x = 0; $x -le $sleep; $x++)
    {
        $sleepInterval = $sleep / 100
        $percentComplete = ($x / $sleep) * 100
        Write-Progress -Activity "Time till next Scroll Lock..." -Status "$percentComplete% Complete..." -PercentComplete ($percentComplete)
        Start-Sleep -Seconds $sleepInterval
    }
    
}