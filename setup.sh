#!/bin/bash
# Setup script for BIO-322 Neural Decoding Project
# Uses uv for fast, reproducible Python environment management

set -e

echo "=== BIO-322 Neural Decoding Setup ==="

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.cargo/bin:$PATH"
fi

echo "Creating virtual environment with uv..."
uv venv .venv

echo "Installing dependencies..."
uv pip install -e .

echo "Installing Jupyter kernel..."
uv pip install ipykernel
uv run python -m ipykernel install --user --name bio322 --display-name "BIO-322 Neural Decoding"

echo ""
echo "=== Setup Complete ==="
echo ""
echo "To activate the environment:"
echo "  source .venv/bin/activate  (Linux/Mac)"
echo "  .venv\\Scripts\\activate    (Windows)"
echo ""
echo "To run the notebook:"
echo "  jupyter notebook notebooks/final_submission.ipynb"
echo ""
echo "Or use Docker:"
echo "  docker-compose up notebook"
