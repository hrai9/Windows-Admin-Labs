# Basic System Inventory Report

$reportFolder = "C:\PowerShell-Labs\Reports"
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$outFile = Join-Path $reportFolder "inventory-report_$timestamp.txt"

$computer = $env:COMPUTERNAME
$os = Get-CimInstance Win32_OperatingSystem
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
$ramGB = [math]::Round(($os.TotalVisibleMemorySize / 1MB), 2)

# Disk (C: as default)
$disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
$diskSizeGB = [math]::Round(($disk.Size / 1GB), 2)
$diskFreeGB = [math]::Round(($disk.FreeSpace / 1GB), 2)

# IP (first active IPv4)
$ip = (Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
       Where-Object { $_.IPAddress -notlike "169.254*" -and $_.IPAddress -ne "127.0.0.1" } |
       Select-Object -First 1).IPAddress

$lines = @(
"===== SYSTEM INVENTORY REPORT ====="
"Date: $(Get-Date)"
"Computer Name: $computer"
"OS: $($os.Caption) ($($os.Version))"
"CPU: $($cpu.Name)"
"RAM (GB): $ramGB"
"Disk C: Size (GB): $diskSizeGB"
"Disk C: Free (GB): $diskFreeGB"
"IPv4 Address: $ip"
"==================================="
)

$lines | Out-File -FilePath $outFile -Encoding UTF8
$lines
"Saved report to: $outFile"