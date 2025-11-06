# PowerShell version of installDrivers.bat

# Function to check if running as administrator
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Function to restart script with administrator privileges
function Restart-WithAdminPrivileges {
    # Check if we've already tried to elevate (equivalent to the UAC parameter check in batch)
    if ($args[0] -ne "UAC") {
        $arguments = "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`" UAC"
        Start-Process powershell.exe -Verb RunAs -ArgumentList $arguments
        exit
    }
}

# Function to display menu and get user choice
function Show-Menu {
    Write-Host "1. Export Drivers"
    Write-Host "2. Install Drivers"
    $userOption = Read-Host "Enter option"
    return $userOption
}

# Function to export drivers
function Export-Drivers {
    # Clean up temp file if it exists (matching batch behavior)
    if (Test-Path "$env:TEMP\getadmin.vbs") {
        Remove-Item "$env:TEMP\getadmin.vbs" -Force
    }
    
    do {
        $targetPath = Read-Host "Enter drivers export location"
        
        # Check if path exists
        if (!(Test-Path $targetPath)) {
            Write-Host "The path entered is not exist. Please enter a valid path."
        }
    } while (!(Test-Path $targetPath))
    
    try {
        dism.exe /online /export-driver /destination:"$targetPath"
        Write-Host "Drivers exported successfully."
    } catch {
        Write-Host "Error exporting drivers: $_"
    }
}

# Function to install drivers
function Install-Drivers {
    # Clean up temp file if it exists (matching batch behavior)
    if (Test-Path "$env:TEMP\getadmin.vbs") {
        Remove-Item "$env:TEMP\getadmin.vbs" -Force
    }
    
    do {
        $driverDirectory = Read-Host "Enter the driver location"
        
        # Check if directory exists
        if (!(Test-Path $driverDirectory)) {
            Write-Host "The specified directory does not exist."
        }
    } while (!(Test-Path $driverDirectory))
    
    try {
        pnputil.exe /add-driver "$driverDirectory\*.inf" /subdirs /install
        Write-Host "Drivers installed successfully."
    } catch {
        Write-Host "Error installing drivers: $_"
    }
}

# Main script execution
# Check if we're running with admin privileges
if (!(Test-Administrator)) {
    Restart-WithAdminPrivileges $args[0]
} else {
    # Show menu and handle user choice
    $option = Show-Menu

    switch ($option) {
        "1" { Export-Drivers }
        "2" { Install-Drivers }
        default { Write-Host "Unknown Option." }
    }

    # Pause before exit (equivalent to PAUSE command in batch)
    Write-Host "Press Enter to exit..."
    Read-Host | Out-Null
}