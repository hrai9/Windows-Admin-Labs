$reportFolder = "C:\PowerShell-Labs\Reports"

# System errors (last 50)
$systemErrors = Get-WinEvent -LogName System -MaxEvents 300 |
  Where-Object { $_.LevelDisplayName -eq "Error" } |
  Select-Object -First 50 TimeCreated, Id, ProviderName, Message

$systemErrors | Export-Csv "$reportFolder\system_errors.csv" -NoTypeInformation -Encoding UTF8

# Security failed logins (Event ID 4625). Might require admin + proper auditing.
try {
  $failedLogins = Get-WinEvent -FilterHashtable @{LogName="Security"; Id=4625} -MaxEvents 50 |
    Select-Object -First 20 TimeCreated, Id, Message

  $failedLogins | Export-Csv "$reportFolder\failed_logins.csv" -NoTypeInformation -Encoding UTF8
  "Exported failed_logins.csv"
} catch {
  "Could not access Security log or no events available. Exporting a note instead."
  "Security log unavailable or no 4625 events found." | Out-File "$reportFolder\failed_logins.csv"
}

"Exported system_errors.csv"
