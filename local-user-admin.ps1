param(
  [string]$Username = "labuser1"
)

$csvOut = "C:\PowerShell-Labs\Reports\local-users.csv"

# Create a secure password (for lab use only)
$plain = "TempP@ss123!"
$pass = ConvertTo-SecureString $plain -AsPlainText -Force

# Create user if it doesn't exist
if (-not (Get-LocalUser -Name $Username -ErrorAction SilentlyContinue)) {
  New-LocalUser -Name $Username -Password $pass -FullName "Lab User 1" -Description "PowerShell Lab User"
  "Created local user: $Username (password: $plain)"
} else {
  "User already exists: $Username"
}

# Add to Users group (usually default, but included for practice)
Add-LocalGroupMember -Group "Users" -Member $Username -ErrorAction SilentlyContinue

# Disable user (simulate offboarding)
Disable-LocalUser -Name $Username
"Disabled user: $Username"

# Export local users list
Get-LocalUser | Select-Object Name, Enabled, LastLogon, Description |
  Export-Csv $csvOut -NoTypeInformation -Encoding UTF8

"Exported local users to: $csvOut"
