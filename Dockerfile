FROM python:3.12-slim

WORKDIR /app

# Copy requirements first to leverage Docker caching
COPY requirements.txt .
COPY requirements-dev.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Run as non-root user for better security
RUN useradd -m appuser
USER appuser

# Command to run when container starts
CMD ["python", "-m", "skyguardian"] 