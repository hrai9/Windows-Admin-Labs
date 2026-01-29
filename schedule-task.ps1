$taskName = "DiskMonitorDaily"
$scriptPath = "C:\PowerShell-Labs\disk-monitor.ps1"

# Run daily at 9:00 AM (change if you want)
$trigger = New-ScheduledTaskTrigger -Daily -At 9:00am

# Action: run PowerShell with the script
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""

# Register task (Current user)
Register-ScheduledTask -TaskName $taskName -Trigger $trigger -Action $action -Description "Runs disk-monitor daily" -Force

"Created scheduled task: $taskName"
