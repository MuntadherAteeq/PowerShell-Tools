function Get-UniqueFilename {
    $Count = 1
    $hostname = hostname
    do {
        $filename = "$hostname $Count.txt"
        $Count++
    } until (-not (Test-Path $filename))
    return $filename
}

# Fetch PC details
$PCInfo = @{
    'Serial Number' = (Get-CimInstance win32_bios).SerialNumber
    'Hostname'      = hostname
    'Username'      = $env:USERNAME
    'Product Name'  = (Get-CimInstance Win32_ComputerSystem).Model
    'CPU'           = (Get-CimInstance Win32_Processor).Name
    'Hard Drive'    = (Get-CimInstance Win32_DiskDrive).Model
    'RAM'           = "{0:N2} GB" -f ([math]::Round((Get-CimInstance -ClassName Win32_ComputerSystem).TotalPhysicalMemory / 1GB))
    'Password'      = 'YourPassword'  # Replace with actual password
}

# Exclude default Windows printers
$DefaultPrinters = @(
     "Microsoft Print to PDF", "Fax", "Microsoft XPS Document Writer",
    "OneNote", "Send To OneNote", "OneNote for Windows 10", "OneNote (Desktop)", "AnyDesk Printer","Send to Microsoft OneNote 16 Driver"
)


# Status code to description mapping
$StatusDescriptions = @{
    "0" = "Other"
    "1" = "Unknown"
    "2" = "Idle"
    "3" = "Normal"
    "4" = "Warm-up"
    "5" = "Stopped Printing"
    "6" = "Offline"
}

# Determine maximum key and value lengths for formatting alignment
$maxKeyLength = ($PCInfo.Keys | Measure-Object -Maximum Length).Maximum
$maxValueLength = ($PCInfo.Values | Measure-Object -Maximum Length).Maximum

# Create formatted output for PC details
$Details = @"
 PC Details:
+{0}+{1}+
| {2} | {3} |
+{0}+{1}+
"@ -f ('-' * ($maxKeyLength + 2)), ('-' * ($maxValueLength + 2)), ('Specification'.PadRight($maxKeyLength)), ('Value'.PadRight($maxValueLength))

foreach ($key in $PCInfo.Keys) {
    $Details += "`n| {0,-$maxKeyLength} | {1,-$maxValueLength} |" -f $key, $PCInfo[$key]
    $Details += "`n+{0}+{1}+" -f ('-' * ($maxKeyLength + 2)), ('-' * ($maxValueLength + 2))
}

# Get non-default printers
$Printers = Get-Printer | Where-Object { $DefaultPrinters -notcontains $_.Name } |
    Select-Object Name, DriverName, PortName, PrinterStatus

# Add Printer Details
$Details += @"
`n`n Printer Details:
+--------------------------------------------------------------+--------------------------------------------------------------+--------------------------------+--------+
| Name                                                         | Driver                                                       | Port                           | Status |
+--------------------------------------------------------------+--------------------------------------------------------------+--------------------------------+--------+
"@
if ($Printers) {
    foreach ($printer in $Printers) {
        $statusDescription = $StatusDescriptions[$printer.PrinterStatus] -or "Unknown Status"
        $Details += "`n| {0,-60} | {1,-60} | {2,-30} | {3,-6} |" -f $printer.Name, $printer.DriverName, $printer.PortName, $statusDescription
    }
} else {
    $Details += "`n| No printers found."
}
$Details += "`n+--------------------------------------------------------------+--------------------------------------------------------------+--------------------------------+--------+`n"

# Fetch physical disks and their types (SSD/HDD) along with their models
$PhysicalDisks = Get-PhysicalDisk | Select-Object DeviceID, MediaType, Size, Model

# Add Physical Disk Details
$Details += @"
`n`n Physical Disk Details:
+-------------+-------------+-------------+----------------------------------+
| Device ID   | Media Type  | Size        | Model                            |
+-------------+-------------+-------------+----------------------------------+
"@
if ($PhysicalDisks) {
    foreach ($disk in $PhysicalDisks) {
        $Details += "`n| {0,-11} | {1,-11} | {2,-11} | {3,-32} |" -f $disk.DeviceID, $disk.MediaType, [math]::round($disk.Size / 1GB, 2), $disk.Model
    }
} else {
    $Details += "`n| No physical disks found."
}
$Details += "`n+-------------+-------------+-------------+----------------------------------+`n"

# Fetch installed programs and their versions
$uninstallPaths = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall"
)

$Details += @"
`n`n Installed Programs:
+----------------------------------------------------------------------------------------+-----------------------------+
| Program Name                                                                           | Version                     |
+----------------------------------------------------------------------------------------+-----------------------------+
"@

foreach ($path in $uninstallPaths) {
    Get-ItemProperty -Path "$path\*" | ForEach-Object {
        if ($_.DisplayName) {
            $version = if ($_.DisplayVersion) { $_.DisplayVersion } else { "N/A" }
            $Details += "`n| {0,-85}  | {1,-27} |" -f $_.DisplayName, $version
        }
    }
}

$Details += "`n+----------------------------------------------------------------------------------------+-----------------------------+`n"

# Save to file
$filename = Get-UniqueFilename
$Details | Out-File -FilePath $filename

# Open file in Notepad
Start-Process notepad.exe $filename