# Load credentials from .env file
$envFile = ".\.env"

if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        $name, $value = $_ -split '=', 2
        Set-Content -Path "env:\$name" -Value $value
    }
} else {
    Write-Host "❌ ERROR: .env file not found! Please create one with USERNAME and PASSWORD."
    exit 1
}

# Activate the virtual environment
$env:VIRTUAL_ENV = ".\env"
$env:Path = "$env:VIRTUAL_ENV\Scripts;$env:Path"
.\env\Scripts\Activate.ps1

# Run the Python script with credentials from .env
python .\src\main.py --username "$env:USERNAME" --password "$env:PASSWORD"

# Deactivate virtual environment (optional)
deactivate
