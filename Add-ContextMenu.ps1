# Define the registry path for the context menu
$regPath = "HKCR\*\shell\BlockInFirewall"

# Create the registry key for the context menu
New-Item -Path $regPath -Force | Out-Null
Set-ItemProperty -Path $regPath -Name "(Default)" -Value "Block in Firewall"

# Define the command to execute when the context menu is clicked
$command = "powershell.exe -File `"$PSScriptRoot\BlockInFirewall.ps1`" `"%1`""

# Create the command registry key
New-Item -Path "$regPath\command" -Force | Out-Null
Set-ItemProperty -Path "$regPath\command" -Name "(Default)" -Value $command

Write-Host "Context menu 'Block in Firewall' added successfully." -ForegroundColor Green
