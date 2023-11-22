# Check if ADB is already installed
if (Test-Path "C:\Program Files (x86)\Android\android-sdk\platform-tools\adb.exe") {
    Write-Output "ADB is already installed. Skipping installation."
} else {
    # Download ADB
    $downloadUrl = "https://dl.google.com/android/repository/platform-tools_r31.0.0-windows.zip"
    $downloadPath = Join-Path $env:TEMP "platform-tools.zip"
    Invoke-WebRequest -Uri $downloadUrl -OutFile $downloadPath

    # Extract ADB
    $extractPath = Join-Path $env:TEMP "android-sdk"
    New-Item -Path $extractPath -ItemType Directory
    Expand-Archive -Path $downloadPath -DestinationPath $extractPath

    # Move ADB to the system PATH
    $adbPath = Join-Path $extractPath "platform-tools\adb.exe"
    $env:PATH += $adbPath + ";"
    Write-Output "ADB installed successfully."
}

# Verify ADB installation
if (!(Test-Path "C:\Program Files (x86)\Android\android-sdk\platform-tools\adb.exe")) {
    Write-Error "Failed to install ADB. Please check the download and extraction process."
    exit
}

# Test ADB connection
$devices = adb devices
if ($devices.Count -eq 0) {
    Write-Output "No connected devices found."
} else {
    Write-Output "Connected devices:"
    $devices | ForEach-Object {
        Write-Output $_.DeviceID
    }
}
