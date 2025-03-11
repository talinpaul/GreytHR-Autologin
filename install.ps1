# Ensure PowerShell stops on errors
$ErrorActionPreference = "Stop"

# Check if Scoop is installed
Write-Host "Checking for Scoop installation..."
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Scoop is not installed. Trying to install Scoop and try again."
    # Set execution policy to allow running scripts
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    # Download and execute Scoop installer
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
} else {
    Write-Output "Scoop is already installed."
}

# Update Scoop to the latest version
Write-Host "Updating Scoop..."
scoop update

# Function to install a package using Scoop if it's not already installed
function Install-Package-If-Needed {
    param (
        [string]$packageName
    )
    if (-not (scoop list $packageName -q)) {
        Write-Host "Installing $packageName..."
        scoop install $packageName
    } else {
        Write-Host "$packageName is already installed."
    }
}


# Install Python using Scoop
Install-Package-If-Needed "python"

# Install Mozilla Firefox using Scoop
Install-Package-If-Needed "firefox"

# Install GeckoDriver using Scoop
Install-Package-If-Needed "geckodriver"

Write-Output "Installation of Mozilla Firefox and GeckoDriver is complete."

# Check if Python is installed
Write-Host "Checking for Python installation..."
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Python is not installed. Please install Python and try again."
    exit 1
}

# Ensure the `venv` module is installed
Write-Host "Checking if 'venv' module is installed..."
$venv_installed = python -c "import venv" 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ 'venv' module is not installed. Installing it now..."
    python -m ensurepip --default-pip
}

# Create a virtual environment
Write-Host "Creating virtual environment..."
python -m venv env

# Activate the virtual environment
Write-Host "Activating virtual environment..."
$env:VIRTUAL_ENV = ".\env"
$env:Path = "$env:VIRTUAL_ENV\Scripts;$env:Path"
.\env\Scripts\Activate.ps1

# Upgrade pip
Write-Host "Upgrading pip..."
pip install --upgrade pip

# Install required dependencies
Write-Host "Installing dependencies from requirements.txt..."
pip install -r requirements.txt

Write-Host "✅ Setup complete!"
