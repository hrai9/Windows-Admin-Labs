# Windows-Admin-Labs
Hands-on PowerShell scripts demonstrating core Windows system administration tasks

## This repository contains PowerShell scripts for:
- System inventory reporting
- Service health monitoring
- Event log parsing
- Disk space alerting
- Local user management
- Bulk user creation from CSV
- Process and software auditing
- Task scheduling automation

## Skills Demonstrated
- PowerShell automation
- Windows system administration
- Event log analysis
- Service monitoring and remediation
- Identity and access management

--------------------------------------------------------------------------

### inventory.ps1 — System Inventory
Collects basic system information for auditing and troubleshooting

**What it does**
- Gathers computer name, OS version, CPU, RAM
- Checks disk size and free space
- Detects active IPv4 address
- Generates a timestamped inventory report

**Outputs**
- 'Reports/inventory-report_<timestamp>.txt'

--------------------------------------------------------------------------

### service-check.ps1 — Service Health Checker
Identifies stopped services that are configured to start automatically and optionally attempts to restart them

**What it does**
- Scans all Windows services
- Filters for services with Startup Type = Automatic and Status = Stopped
- Optionally restarts affected services using a command-line switch
- Logs actions and failures

**Outputs**
- `Logs/service-actions.log`

**Run options**
powershell:
.\service-check.ps1
.\service-check.ps1 -RestartStopped

--------------------------------------------------------------------------

### log-parse.ps1 - Event Log Parsing
Extracts useful error and security information from Windows Event Logs

**What it does**
- Retrieves recent System log error events
- Attempts to retrieve Security log failed login events (Event ID 4625)
- Handles missing permissions or unavailable events gracefully
- Exports results for review and auditing

**Outputs**
- 'Reports/system_errors.csv'
- 'Reports/failed_logins.csv (or explanatory note if unavailable)'

--------------------------------------------------------------------------
### disk-monitor.ps1 - Disk Space Monitoring & Alerts
Monitors disk usage and generates alerts when free space falls below a defined threshold

**What it does**
- Checks all local disks
- Calculates free space percentage and available GB
- Writes alerts when free space drops below the configured threshold
- Allows threshold customization via parameter

**Outputs**
- 'Logs/alerts.txt'

**Run Options**
.\disk-monitor.ps1
.\disk-monitor.ps1 -Threshold 20

--------------------------------------------------------------------------

### local-user-admin.ps1 — Local User Management
Simulates basic user onboarding and offboarding tasks on a Windows system

**What it does**
- Creates a local user if it does not exist
- Adds user to a local group
- Disables the user account to simulate offboarding
- Exports a list of all local users

**Outputs**
- 'Reports/local-users.csv'

--------------------------------------------------------------------------

### create-users-from-csv.ps1 — Bulk User Creation from CSV
Automates local user provisioning using data from a CSV file

**What it does**
- Reads usernames, full names, and departments from a CSV
- Creates local users if they do not already exist
- Logs created, skipped, and failed accounts
- Simulates bulk onboarding workflows used in Active Directory

**Inputs**
users.csv

**Outputs**
- 'Logs/bulk-user-create.log'

--------------------------------------------------------------------------

### audit.ps1 — Process & Software Audit
Provides a snapshot of system resource usage and installed applications

**What it does**
- Identifies the top 10 processes by memory usage
- Enumerates installed software from the registry
- Exports findings for review and documentation

**Outputs**
- 'Reports/top_processes_<timestamp>.csv'
- 'Reports/installed_software_<timestamp>.csv'

--------------------------------------------------------------------------

### schedule-task.ps1 — Scheduled Task Automation
Automates recurring execution of monitoring scripts

**What it does**
- Creates a scheduled task to run disk-monitor.ps1 daily
- Configures task triggers and execution settings
- Allows verification and manual execution

**Outputs**
- 'Scheduled Tasks: DiskMonitorDaily'