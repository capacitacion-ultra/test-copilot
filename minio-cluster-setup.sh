#!/bin/bash

# *****************************************************
# Script to create a MinIO cluster with multiple nodes
# *****************************************************

# Stop and remove the existing MinIO container
docker stop minio
docker rm minio

# Check if at least one argument (IP address) is provided
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <IP1> <IP2> ... <IPn>"
  exit 1
fi

# Environment variables for MinIO (adjust these if needed)
MINIO_ROOT_USER="admin"
MINIO_ROOT_PASSWORD="UrbiEtOrbi1_"
mkdir -p ~/minio-data

# Construct the MinIO server command with all IP addresses
SERVER_CMD="minio/minio server"

for ip in "$@"; do
  SERVER_CMD="$SERVER_CMD http://$ip/data"
done

# Run the Docker command
docker run -d \
  --name minio \
  -v ~/minio-data:/data \
  -e "MINIO_ROOT_USER=$MINIO_ROOT_USER" \
  -e "MINIO_ROOT_PASSWORD=$MINIO_ROOT_PASSWORD" \
  --net=host \
  $SERVER_CMD --console-address ":9001"

# Print the executed command for verification
echo "Executed Docker command:"
echo "docker run -d --name minio -p $API_PORT:$API_PORT -p $CONSOLE_PORT_DOCKER:$CONSOLE_PORT -v ~/minio-data:/data -e MINIO_ROOT_USER=$MINIO_ROOT_USER -e MINIO_ROOT_PASSWORD=$MINIO_ROOT_PASSWORD $SERVER_CMD  --console-address ':9001'"
