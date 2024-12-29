
# Define the log file path

$LogFilePath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'), 'IP_Address_Changes.txt')


# Ensure the log directory exists

$LogDir = [System.IO.Path]::GetDirectoryName($LogFilePath)

if (-not (Test-Path $LogDir)) {

    New-Item -ItemType Directory -Path $LogDir | Out-Null

}


# Function to retrieve the public IP address

function Get-PublicIPAddress {

    try {

        return Invoke-RestMethod -Uri "https://api.ipify.org?format=text"

    } catch {

        return "Unable to retrieve public IP"

    }

}


# Function to retrieve the PC's local IPv4 address

function Get-LocalIPAddress {

    $ip = (Get-NetIPAddress -AddressFamily IPv4 |

           Where-Object { $_.PrefixOrigin -eq "Dhcp" -or $_.PrefixOrigin -eq "Manual" }).IPAddress

    return $ip -join ", "

}


# Function to retrieve the router IP address (Default Gateway)

function Get-RouterIPAddress {

    $gateway = (Get-NetRoute -DestinationPrefix "0.0.0.0/0" | Select-Object -First 1).NextHop

    return $gateway

}


# Infinite loop to execute daily

while ($true) {

    # Collect current data

    $PublicIP = Get-PublicIPAddress

    $LocalIP = Get-LocalIPAddress

    $RouterIP = Get-RouterIPAddress

    $Date = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")


    # Format the output

    $Output = @(

        "Date: $Date",

        "Public IP Address . . . . . . . . : $PublicIP",

        "PC IPv4 Address . . . . . . . . . : $LocalIP",

        "Router IP Address . . . . . . . . : $RouterIP",

        "---------------------------------------------"

    ) -join "`n"


    # Check if the log file exists

    if (-not (Test-Path $LogFilePath)) {

        # Create the file and add the header

        Add-Content -Path $LogFilePath -Value "IP Address Change Log`n---------------------------------------------`n"

    }


    # Read the last logged entry (if any)

    $LastLog = Get-Content -Path $LogFilePath -Tail 5 | Out-String


    # Append new entry only if there are changes

    if ($LastLog -notlike "*$PublicIP*" -or $LastLog -notlike "*$LocalIP*" -or $LastLog -notlike "*$RouterIP*") {

        Add-Content -Path $LogFilePath -Value $Output

    }


    # Wait for 24 hours

    Start-Sleep -Seconds 86400

}
