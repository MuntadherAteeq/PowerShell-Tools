#Disable Bing Search in Windows 11

# Disable web search in Start Menu
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
Set-ItemProperty -Path $regPath -Name "BingSearchEnabled" -Value 0
Set-ItemProperty -Path $regPath -Name "CortanaConsent" -Value 0

# Disable web search from File Explorer
$regPathExplorer = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-ItemProperty -Path $regPathExplorer -Name "DisableWebSearch" -Value 1


