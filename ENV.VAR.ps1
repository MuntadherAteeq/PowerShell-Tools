# Adding a path to the system Path variable
$nmapPath = ""

# Get the current system Path variable
$currentPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)

# Check if the path is already in the Path variable
if ($currentPath -notlike "*${nmapPath}*") {
    # Append the new path
    $newPath = "$currentPath;$nmapPath"
    
    # Set the updated Path variable
    [System.Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::Machine)
    Write-Output "Nmap path added to system Path variable."
} else {
    Write-Output "Nmap path is already present in the system Path variable."
}