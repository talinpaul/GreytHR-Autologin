# Ensure PowerShell stops on errors
$ErrorActionPreference = "Stop"

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
