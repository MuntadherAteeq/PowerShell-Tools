# Define the application to block
$applicationPath = "C:\Program Files\Affinity\Photo 2\Photo.exe" # Replace with the full path of your software

# Define rule names
$ruleNameInbound = "Affinty Photo Blocker"
$ruleNameOutbound = "Affinty Photo Blocker"

# Check if the file exists
if (-Not (Test-Path -Path $applicationPath)) {
    Write-Host "Error: Application not found at $applicationPath. Please check the path and try again." -ForegroundColor Red
    exit
}

# Create inbound firewall rule
Write-Host "Creating inbound firewall rule..."
New-NetFirewallRule `
    -DisplayName $ruleNameInbound `
    -Direction Inbound `
    -Action Block `
    -Program $applicationPath `
    -Description "Blocks inbound traffic for YourSoftware" `
    -Enabled True `
    -Profile Any

# Create outbound firewall rule
Write-Host "Creating outbound firewall rule..."
New-NetFirewallRule `
    -DisplayName $ruleNameOutbound `
    -Direction Outbound `
    -Action Block `
    -Program $applicationPath `
    -Description "Blocks outbound traffic for YourSoftware" `
    -Enabled True `
    -Profile Any

Write-Host "Firewall rules created successfully to block internet access for $applicationPath." -ForegroundColor Green