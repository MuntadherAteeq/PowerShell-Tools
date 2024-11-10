#Disable Bing Search in Windows 11

# Disable web search in Start Menu
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
Set-ItemProperty -Path $regPath -Name "BingSearchEnabled" -Value 0
Set-ItemProperty -Path $regPath -Name "CortanaConsent" -Value 0

# Disable web search from File Explorer
$regPathExplorer = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-ItemProperty -Path $regPathExplorer -Name "DisableWebSearch" -Value 1

# Disable Cortana
$regPathCortana = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
New-ItemProperty -Path $regPathCortana -Name "NoCortana" -PropertyType DWord -Value 1 -Force

# Inform the user about changes
Write-Host "Bing search has been disabled. A system restart is recommended for all changes to take effect."

# Optional: Uninstall Bing-related apps if applicable (e.g., Bing Weather)
# Get-AppxPackage *bing* | Remove-AppxPackage

# End of script
