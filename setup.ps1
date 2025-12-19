# Setup script for BIO-322 Neural Decoding Project (Windows)
# Uses uv for fast, reproducible Python environment management

Write-Host "=== BIO-322 Neural Decoding Setup ===" -ForegroundColor Cyan

# Check if uv is installed
if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    Write-Host "Installing uv..." -ForegroundColor Yellow
    powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
    $env:Path = "$env:USERPROFILE\.cargo\bin;$env:Path"
}

Write-Host "Creating virtual environment with uv..." -ForegroundColor Yellow
uv venv .venv

Write-Host "Installing dependencies..." -ForegroundColor Yellow
uv pip install -e .

Write-Host "Installing Jupyter kernel..." -ForegroundColor Yellow
uv pip install ipykernel
& .venv\Scripts\python.exe -m ipykernel install --user --name bio322 --display-name "BIO-322 Neural Decoding"

Write-Host ""
Write-Host "=== Setup Complete ===" -ForegroundColor Green
Write-Host ""
Write-Host "To activate the environment:" -ForegroundColor Cyan
Write-Host "  .venv\Scripts\activate"
Write-Host ""
Write-Host "To run the notebook:" -ForegroundColor Cyan
Write-Host "  jupyter notebook notebooks\final_submission.ipynb"
Write-Host ""
Write-Host "Or use Docker:" -ForegroundColor Cyan
Write-Host "  docker-compose up notebook"
