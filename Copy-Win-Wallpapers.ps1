# Define the source and target folders
$sourceFolder = Join-Path -Path $env:LOCALAPPDATA -ChildPath "Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets"
$targetFolder = Join-Path -Path (Get-Location) -ChildPath "Wallpapers"

# Ensure the target folder exists or create it
if (-not (Test-Path -Path $targetFolder)) {
    New-Item -ItemType Directory -Path $targetFolder | Out-Null
}

# Function to process images
function ProcessImages {
    Get-ChildItem -Path $sourceFolder -File | ForEach-Object {
        $sourcePath = $_.FullName
        $targetPath = Join-Path -Path $targetFolder -ChildPath "$($_.BaseName).jpg"

        # Check if the target file already exists
        if (-not (Test-Path -Path $targetPath)) {
            try {
                # Copy the file with a .jpg extension
                Copy-Item -Path $sourcePath -Destination $targetPath
            } catch {
                Write-Host "Error copying file $($_.Name): $_"
            }
        }
    }
}

# Run the process
ProcessImages
Set-Location $targetFolder
Start-Process .
Write-Host "Wallpapers copied to $targetFolder"
