# Use Python 3.13 as base image
FROM python:3.13-slim

# All paths are volume-mounted at runtime from the repo root.
WORKDIR /work/codegen

# Install dependencies
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Default command runs codegen against the mounted repo.
CMD ["python", "main.py"]
