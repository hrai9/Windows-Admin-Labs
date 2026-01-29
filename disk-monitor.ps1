param(
  [int]$Threshold = 15
)

$alertFile = "C:\PowerShell-Labs\Logs\alerts.txt"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$drives = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"  # local disks only

foreach ($d in $drives) {
  if ($d.Size -gt 0) {
    $percentFree = [math]::Round(($d.FreeSpace / $d.Size) * 100, 2)
    $freeGB = [math]::Round(($d.FreeSpace / 1GB), 2)

    if ($percentFree -lt $Threshold) {
      $line = "[$timestamp] ALERT: Drive $($d.DeviceID) is low. Free: $percentFree% ($freeGB GB). Threshold: $Threshold%"
      $line | Tee-Object -FilePath $alertFile -Append
    }
  }
}

"Done. Alerts saved to $alertFile (if any were triggered)."
