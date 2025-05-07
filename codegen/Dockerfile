# Use Python 3.13 as base image
FROM python:3.13-slim

# Set working directory
WORKDIR /app

# Copy requirements first to leverage Docker cache
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Create necessary directories
RUN mkdir -p /app/sql/endpoints

# Copy the codegen directory contents
COPY . .

# Create the sql/endpoints directory in the parent directory
RUN mkdir -p ../sql/endpoints

# Set the entrypoint to run the codegen script
ENTRYPOINT ["python", "main.py"] 