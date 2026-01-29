$reportFolder = "C:\PowerShell-Labs\Reports"
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

# Top 10 processes by memory
Get-Process |
  Sort-Object WS -Descending |
  Select-Object -First 10 Name, Id, @{Name="MemoryMB";Expression={[math]::Round($_.WS/1MB,2)}} |
  Export-Csv "$reportFolder\top_processes_$timestamp.csv" -NoTypeInformation -Encoding UTF8

# Installed software (common method via registry)
$paths = @(
"HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
"HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

$apps = foreach ($p in $paths) {
  Get-ItemProperty $p -ErrorAction SilentlyContinue |
    Where-Object { $_.DisplayName } |
    Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
}

$apps | Sort-Object DisplayName |
  Export-Csv "$reportFolder\installed_software_$timestamp.csv" -NoTypeInformation -Encoding UTF8

"Audit complete. Check the Reports folder."
