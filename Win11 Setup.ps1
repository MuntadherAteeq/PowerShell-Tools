

# ------------------------------------------------------------------------------------------------------------
# Write powershell script to Retrieve the windows 10 context menu for the file explorer 
reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve


# ------------------------------------------------------------------------------------------------------------
# Write powershell script to Disable web search in Start Menu
# Disable web search in Start Menu
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
Set-ItemProperty -Path $regPath -Name "BingSearchEnabled" -Value 0
Set-ItemProperty -Path $regPath -Name "CortanaConsent" -Value 0

# Confirm the registry setting is applied
$WebSearch = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled"


# ------------------------------------------------------------------------------------------------------------
# Write powershell script to uninstall Windows web Experience Pack
winget.exe uninstall "Windows web Experience Pack" 


# ------------------------------------------------------------------------------------------------------------
# Write powershell script to Disable data collection from the registry 
# Disable data collection from the registry
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Type DWord

# Confirm the registry setting is applied
$DataCollection = Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" 


# ------------------------------------------------------------------------------------------------------------
# Write powershell script to disable Connected User Experiences and Telemetry service from services.msc
# Stop the service if it is running
Stop-Service -Name "DiagTrack" -ErrorAction SilentlyContinue

# Disable the service
Set-Service -Name "DiagTrack" -StartupType Disabled

# Confirm the service is disabled
$UserExperiences = Get-Service -Name "DiagTrack"


# ------------------------------------------------------------------------------------------------------------
# Write powershell script to disable Assigned Access Manager Service from services.msc
# Stop the service if it is running
Stop-Service -Name "AssignedAccessManagerSvc" -ErrorAction SilentlyContinue

# Disable the service
Set-Service -Name "AssignedAccessManagerSvc" -StartupType Disabled

# Confirm the service is disabled
$AssignedAccessManager = Get-Service -Name "AssignedAccessManagerSvc"


# ------------------------------------------------------------------------------------------------------------
# Write powershell script to disable BitLocker Drive Encryption Service from services.msc
# Stop the service if it is running
Stop-Service -Name "BDESVC" -ErrorAction SilentlyContinue

# Disable the service
Set-Service -Name "BDESVC" -StartupType Disabled

# Confirm the service is disabled
$BitLocker = Get-Service -Name "BDESVC"


# ------------------------------------------------------------------------------------------------------------
# Write powershell script to disable Bluetooth Support Service from services.msc
# Stop the service if it is running
Stop-Service -Name "bthserv" -ErrorAction SilentlyContinue

# Disable the service
Set-Service -Name "bthserv" -StartupType Disabled

# Confirm the service is disabled
$Bluetooth = Get-Service -Name "bthserv"


# ------------------------------------------------------------------------------------------------------------
# Write powershell script to disable Diagnostic Execution Service from services.msc
# Stop the service if it is running
Stop-Service -Name "DiagSvc" -ErrorAction SilentlyContinue

# Disable the service
Set-Service -Name "DiagSvc" -StartupType Disabled

# Confirm the service is disabled
$DiagnosticExecution = Get-Service -Name "DiagSvc"


# ------------------------------------------------------------------------------------------------------------
# Write powershell script to disable Diagnostic Policy Service from services.msc
# Stop the service if it is running
Stop-Service -Name "DPS" -ErrorAction SilentlyContinue

# Disable the service
Set-Service -Name "DPS" -StartupType Disabled

# Confirm the service is disabled
$DiagnosticPolicy = Get-Service -Name "DPS"


# ------------------------------------------------------------------------------------------------------------
# Write powershell script to disable Diagnostic Service Host from services.msc
# Stop the service if it is running
Stop-Service -Name "WdiServiceHost" -ErrorAction SilentlyContinue

# Disable the service
Set-Service -Name "WdiServiceHost" -StartupType Disabled

# Confirm the service is disabled
$DiagnosticServiceHost = Get-Service -Name "WdiServiceHost"


# ------------------------------------------------------------------------------------------------------------
# Write powershell script to disable Diagnostic System Host from services.msc
# Stop the service if it is running
Stop-Service -Name "WdiSystemHost" -ErrorAction SilentlyContinue

# Disable the service
Set-Service -Name "WdiSystemHost" -StartupType Disabled

# Confirm the service is disabled
$DiagnosticSystemHost = Get-Service -Name "WdiSystemHost"


# ------------------------------------------------------------------------------------------------------------
# Write powershell script to disable Geolocation Service from services.msc
# Stop the service if it is running
Stop-Service -Name "lfsvc" -ErrorAction SilentlyContinue

# Disable the service
Set-Service -Name "lfsvc" -StartupType Disabled

# Confirm the service is disabled
$Geolocation = Get-Service -Name "lfsvc"


# ------------------------------------------------------------------------------------------------------------
# Write powershell script to disable Phone Service from services.msc
# Stop the service if it is running
Stop-Service -Name "PhoneSvc" -ErrorAction SilentlyContinue

# Disable the service
Set-Service -Name "PhoneSvc" -StartupType Disabled

# Confirm the service is disabled
$PhoneService = Get-Service -Name "PhoneSvc"


# ------------------------------------------------------------------------------------------------------------
# Write powershell script to disable Windows Error Reporting Service from services.msc
# Stop the service if it is running
Stop-Service -Name "WerSvc" -ErrorAction SilentlyContinue

# Disable the service
Set-Service -Name "WerSvc" -StartupType Disabled

# Confirm the service is disabled
$WindowsErrorReporting = Get-Service -Name "WerSvc"


# ------------------------------------------------------------------------------------------------------------
# Write powershell script to disable xbox services from services.msc
# Stop the service if it is running
Stop-Service -Name "XblAuthManager" -ErrorAction SilentlyContinue
Stop-Service -Name "XblGameSave" -ErrorAction SilentlyContinue
Stop-Service -Name "XboxNetApiSvc" -ErrorAction SilentlyContinue

# Disable the service
Set-Service -Name "XblAuthManager" -StartupType Disabled
Set-Service -Name "XblGameSave" -StartupType Disabled
Set-Service -Name "XboxNetApiSvc" -StartupType Disabled

# Confirm the service is disabled
$XblAuthManager = Get-Service -Name "XblAuthManager"
$XblGameSave = Get-Service -Name "XblGameSave"
$XboxNetApiSvc = Get-Service -Name "XboxNetApiSvc"


# ------------------------------------------------------------------------------------------------------------
# print all the services and registry settings that have been disabled with ❌ if they are unsuccessfully disabled and ✅ if they are successfully disabled

Write-Host "Services and Registry Settings that have been disabled:"
Write-Host "Connected User Experiences and Telemetry service: $(if ($UserExperiences.Status -eq "Stopped" -and $UserExperiences.StartType -eq "Disabled") { "✅" } else { "❌" })"
Write-Host "Assigned Access Manager Service: $(if ($AssignedAccessManager.Status -eq "Stopped" -and $AssignedAccessManager.StartType -eq "Disabled") { "✅" } else { "❌" })"
Write-Host "BitLocker Drive Encryption Service: $(if ($BitLocker.Status -eq "Stopped" -and $BitLocker.StartType -eq "Disabled") { "✅" } else { "❌" })"
Write-Host "Bluetooth Support Service: $(if ($Bluetooth.Status -eq "Stopped" -and $Bluetooth.StartType -eq "Disabled") { "✅" } else { "❌" })"
Write-Host "Data Collection from the registry: $(if ($DataCollection.AllowTelemetry -eq 0) { "✅" } else { "❌" })"
Write-Host "Windows web Experience Pack: $(if ($? -eq $true) { "✅" } else { "❌" })"
Write-Host "Diagnostic Execution Service: $(if ($DiagnosticExecution.Status -eq "Stopped" -and $DiagnosticExecution.StartType -eq "Disabled") { "✅" } else { "❌" })"
Write-Host "Diagnostic Policy Service: $(if ($DiagnosticPolicy.Status -eq "Stopped" -and $DiagnosticPolicy.StartType -eq "Disabled") { "✅" } else { "❌" })"
Write-Host "Diagnostic Service Host: $(if ($DiagnosticServiceHost.Status -eq "Stopped" -and $DiagnosticServiceHost.StartType -eq "Disabled") { "✅" } else { "❌" })"
Write-Host "Diagnostic System Host: $(if ($DiagnosticSystemHost.Status -eq "Stopped" -and $DiagnosticSystemHost.StartType -eq "Disabled") { "✅" } else { "❌" })"
Write-Host "Geolocation Service: $(if ($Geolocation.Status -eq "Stopped" -and $Geolocation.StartType -eq "Disabled") { "✅" } else { "❌" })"
Write-Host "Phone Service: $(if ($PhoneService.Status -eq "Stopped" -and $PhoneService.StartType -eq "Disabled") { "✅" } else { "❌" })"
Write-Host "Windows Error Reporting Service: $(if ($WindowsErrorReporting.Status -eq "Stopped" -and $WindowsErrorReporting.StartType -eq "Disabled") { "✅" } else { "❌" })"
Write-Host "Xbox Services: $(if ($XblAuthManager.Status -eq "Stopped" -and $XblAuthManager.StartType -eq "Disabled" -and $XblGameSave.Status -eq "Stopped" -and $XblGameSave.StartType -eq "Disabled" -and $XboxNetApiSvc.Status -eq "Stopped" -and $XboxNetApiSvc.StartType -eq "Disabled") { "✅" } else { "❌" })"
Write-Host "Web Search in Start Menu: $(if ($WebSearch.BingSearchEnabled -eq 0) { "✅" } else { "❌" })"
# ------------------------------------------------------------------------------------------------------------

