# Service Health Checker

param(
  [switch]$RestartStopped
)

$logFile = "C:\PowerShell-Labs\Logs\service-actions.log"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

"[$timestamp] Starting service check..." | Out-File $logFile -Append

# Find services that are stopped but set to Automatic
$stoppedAuto = Get-Service |
  Where-Object { $_.Status -eq "Stopped" } |
  ForEach-Object {
    $svcName = $_.Name
    $wmi = Get-CimInstance Win32_Service -Filter "Name='$svcName'"
    [PSCustomObject]@{
      Name = $_.Name
      DisplayName = $_.DisplayName
      StartMode = $wmi.StartMode
      Status = $_.Status
    }
  } | Where-Object { $_.StartMode -eq "Auto" }

if (-not $stoppedAuto) {
  "No stopped Automatic services found." | Tee-Object -FilePath $logFile -Append
  exit
}

"Stopped + Automatic services:" | Tee-Object -FilePath $logFile -Append

# Print to Screen
$stoppedAuto | Format-Table -AutoSize

# Write to the log
$stoppedAuto |
  Format-Table -AutoSize |
  Out-String |
  Out-File -FilePath $logFile -Append

if ($RestartStopped) {
  foreach ($svc in $stoppedAuto) {
    try {
      Start-Service -Name $svc.Name -ErrorAction Stop
      "[$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")] Restarted: $($svc.Name)" | Out-File $logFile -Append
    } catch {
      "[$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")] FAILED: $($svc.Name) - $($_.Exception.Message)" | Out-File $logFile -Append
    }
  }
  "Done. Actions logged to $logFile"
} else {
  "Run with -RestartStopped to attempt restarts. Example: .\service-check.ps1 -RestartStopped" | Tee-Object -FilePath $logFile -Append
}
