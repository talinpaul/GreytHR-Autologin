
# Activate the virtual environment
$env:VIRTUAL_ENV = ".\env"
$env:Path = "$env:VIRTUAL_ENV\Scripts;$env:Path"
.\env\Scripts\Activate.ps1

# Run the Python script with arguments
python .\src\main.py --username "" --password ""

# Deactivate virtual environment (optional)
deactivate
