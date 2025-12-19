# Build stage
FROM python:3.10-slim AS builder

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# Set working directory
WORKDIR /app

# Copy dependency files and README (required by pyproject.toml)
COPY pyproject.toml README.md ./

# Create virtual environment and install dependencies (not editable in build stage)
RUN uv venv /app/.venv
RUN uv pip install --python /app/.venv/bin/python \
    "numpy>=1.26,<2.0" \
    "pandas>=2.0" \
    "scikit-learn>=1.3" \
    "scipy>=1.11" \
    "matplotlib>=3.7" \
    "seaborn>=0.12" \
    "xgboost>=2.0" \
    "joblib>=1.3" \
    "ipykernel>=6.25" \
    "jupyter>=1.0"

# Runtime stage
FROM python:3.10-slim AS runtime

WORKDIR /app

# Copy virtual environment from builder
COPY --from=builder /app/.venv /app/.venv

# Set environment variables
ENV PATH="/app/.venv/bin:$PATH"
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Copy project files
COPY . .

# Expose Jupyter port
EXPOSE 8888

# Default command: start Jupyter
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''"]
