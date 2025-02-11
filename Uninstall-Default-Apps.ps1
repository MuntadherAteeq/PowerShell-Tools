# List of app names to uninstall
$appsToRemove = @(
    "Microsoft.WindowsFeedbackHub",  # Feedback Hub
    "MicrosoftWindows.Copilot",     # Copilot
    "Microsoft.Office.Desktop",     # Microsoft 365 (Office)
    "Microsoft.BingNews",           # Microsoft Bing Search
    "Clipchamp.Clipchamp",         # Microsoft Clipchamp
    "Microsoft.BingNews",           # Microsoft News
    "MicrosoftTeams",               # Microsoft Teams
    "Microsoft.Todos",              # Microsoft To Do
    "Microsoft.PowerAutomateDesktop", # Power Automate
    "MicrosoftCorporationII.QuickAssist", # Quick Assist
    "Microsoft.MicrosoftSolitaireCollection", # Solitaire & Casual Games
    "Microsoft.MicrosoftStickyNotes", # Sticky Notes
    "Microsoft.BingWeather",        # Weather
    "Microsoft.XboxApp",            # Xbox
    "Microsoft.XboxIdentityProvider" # Xbox Live
)

# Loop through the list and attempt to uninstall each app
foreach ($app in $appsToRemove) {
    $package = Get-AppxPackage -AllUsers | Where-Object { $_.Name -like "*$app*" }
    if ($package) {
        Write-Host "Uninstalling: $($package.Name)"
        Remove-AppxPackage -Package $package.PackageFullName -AllUsers
    } else {
        Write-Host "$app not found. Skipping..."
    }
}

# Additional removal for Microsoft 365 (Office) if installed via system installer
$office = Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name LIKE '%Microsoft 365%'"
if ($office) {
    Write-Host "Uninstalling Microsoft 365 (Office)..."
    $office.Uninstall()
} else {
    Write-Host "Microsoft 365 (Office) not found. Skipping..."
}

# Write a check to see if all apps were removed
$remainingApps = Get-AppxPackage -AllUsers | Where-Object { $appsToRemove -contains $_.Name }
if ($remainingApps) {
    Write-Host "The following apps were not removed:"
    $remainingApps | ForEach-Object { Write-Host $_.Name }
} else {
    Write-Host "All apps have been removed."
}
