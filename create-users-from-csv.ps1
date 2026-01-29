param(
  [string]$CsvPath = "C:\PowerShell-Labs\users.csv"
)

$logFile = "C:\PowerShell-Labs\Logs\bulk-user-create.log"
$plain = "TempP@ss123!"
$pass = ConvertTo-SecureString $plain -AsPlainText -Force

$users = Import-Csv $CsvPath

foreach ($u in $users) {
  try {
    if (-not (Get-LocalUser -Name $u.Username -ErrorAction SilentlyContinue)) {
      New-LocalUser -Name $u.Username -Password $pass -FullName $u.FullName -Description "Dept: $($u.Department)"
      "[$(Get-Date)] CREATED: $($u.Username) Dept=$($u.Department)" | Out-File $logFile -Append
    } else {
      "[$(Get-Date)] SKIP (exists): $($u.Username)" | Out-File $logFile -Append
    }
  } catch {
    "[$(Get-Date)] FAILED: $($u.Username) - $($_.Exception.Message)" | Out-File $logFile -Append
  }
}

"Done. Log: $logFile (password used for all lab accounts: $plain)"
