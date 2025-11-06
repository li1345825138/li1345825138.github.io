# Windows Activation Script - PowerShell Version

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    # Request administrator privileges
    if ($args[0] -ne "UAC") {
        $scriptPath = $MyInvocation.MyCommand.Definition
        $arguments = "& '$scriptPath' UAC"
        
        # Start process with admin rights
        Start-Process powershell -Verb runAs -ArgumentList $arguments
        exit
    }
} else {
    Write-Host "Initializing..."
    
    # Set timezone to Eastern Standard Time
    tzutil /s "Eastern Standard Time" 2>&1 | Out-Null
    
    # Start Windows Time service
    net start w32time 2>&1 | Out-Null
    
    # Resynchronize time
    w32tm /resync 2>&1 | Out-Null
}

# Function to activate Windows with a product key
function Activate-WithKey {
    param(
        [string]$inputKey
    )
    
    if ([string]::IsNullOrEmpty($inputKey)) {
        Activate-ByTroubleshoot
        return
    }
    
    # Remove leading ~ and trailing ; if present
    if ($inputKey.StartsWith("~")) {
        $inputKey = $inputKey.Substring(1)
    }
    if ($inputKey.EndsWith(";")) {
        $inputKey = $inputKey.Substring(0, $inputKey.Length - 1)
    }
    
    Write-Host "Try to activate with key: $inputKey ..."

    Write-Host "Clean old keys..."
    
    # Uninstall product key
    cscript //nologo "$env:windir\system32\slmgr.vbs" /upk
    
    # Clear product key from registry
    cscript //nologo "$env:windir\system32\slmgr.vbs" /cpky
    
    # Install product key
    cscript //nologo "$env:windir\system32\slmgr.vbs" /ipk $inputKey
    
    # Loop to activate
    Activate-Loop
}

# Function to activate in a loop
function Activate-Loop {
    do {
        $result = cscript //nologo "$env:windir\system32\slmgr.vbs" /ato 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Success!"
            Pause-AndExit
        } else {
            Write-Host "Failure, Re-trying..."
            Start-Sleep -Seconds 3
        }
    } while ($true)
}

# Function to activate by troubleshoot
function Activate-ByTroubleshoot {
    cscript //nologo "$env:windir\system32\slmgr.vbs" /ato 2>&1 | Out-Null
    Start-Process "ms-settings:activation"
    Pause-AndExit
}

# Function to pause and exit
function Pause-AndExit {
    Write-Host "Press any key to continue..."
    $HOST.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
    exit
}

# Main execution
if ($isAdmin -or $args[0] -eq "UAC") {
    # Prompt for product key
    $inputKey = Read-Host "Enter activation Key"
    
    # Activate with provided key
    Activate-WithKey -inputKey $inputKey
}