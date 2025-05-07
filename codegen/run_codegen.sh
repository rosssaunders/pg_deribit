#!/bin/bash

# Create necessary directories
mkdir -p ../sql/endpoints

# Build the Docker image
docker build -t deribit-codegen .

# Run the container with proper volume mounts
docker run --rm \
    -v "$(pwd):/app" \
    -v "$(pwd)/../sql:/sql" \
    deribit-codegen 