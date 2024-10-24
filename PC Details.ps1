# Function to get a unique filename
function Get-UniqueFilename {
    $Count = 1
    do {
        $filename = "PC_Details$Count.txt"
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
    'Password'      = 'YourPassword'  # Replace with actual password
}

# Exclude default Windows printers
$DefaultPrinters = @(
    "Microsoft XPS Document Writer", "Microsoft Print to PDF", "Fax", 
    "OneNote", "Send To OneNote", "OneNote for Windows 10", "OneNote (Desktop)"
)

# Get non-default printers
$Printers = Get-Printer | Where-Object { $DefaultPrinters -notcontains $_.Name } |
    Select-Object Name, DriverName, PortName, PrinterStatus

# Determine maximum key length for formatting alignment
$maxKeyLength = ($PCInfo.Keys | Measure-Object -Maximum Length).Maximum

# Create formatted output for PC details
$Details = @"
+---------------------------------------------+
|             PC Details                     |
+---------------------------------------------+
"@
foreach ($key in $PCInfo.Keys) {
    $Details += "`n| {0,-$maxKeyLength}: {1,-30} |`n" -f $key, $PCInfo[$key]
}
$Details += "+---------------------------------------------+`n"

# Add Printer Details
$Details += @"
+---------------------------------------------+
|             Printer Details                |
+---------------------------------------------+
"@
if ($Printers) {
    $Details += $Printers | Format-Table -AutoSize | Out-String
} else {
    $Details += "`n`nNo printers found.`n"
}

# Save to file
$filename = Get-UniqueFilename
$Details | Out-File -FilePath $filename

# Open file in Notepad
Start-Process notepad.exe $filename
