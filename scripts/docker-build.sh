#!/usr/bin/env bash

# Required libs: docker

# Build the Docker image

# Error handling
set -Eeuo pipefail

SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

REPOSITORY_DIR_PATH="$(cd -- "${SCRIPT_DIR}/.." || return > /dev/null 2>&1 && pwd -P)"

# Variables
NGINX_VERSION="$(jq -r '.config.nginxVersion' version.json)"
DOCKER_IMAGE_NAME="$(jq -r '.name' version.json)"
DOCKER_IMAGE_TAG="$(jq -r '.version' version.json)"

echo -e "Build Docker image ${DOCKER_IMAGE_NAME}..."

# Check if multi-arch buildx instance exists
isBuildxInstanceMultiArchExist=$(docker buildx ls | { grep -q "multi-arch" && echo "true" || echo "false"; })

# Create multi-arch buildx instance if it does not exist
if [ "${isBuildxInstanceMultiArchExist}" = "false" ]; then
  echo -e "Creating Docker buildx instance multi-arch..."
  docker buildx create \
    --name multi-arch \
    --platform linux/amd64,linux/arm64 \
    --driver docker-container \
    --use \
    --bootstrap
else
  echo -e "Use Docker buildx instance multi-arch..."
fi

echo -e "Building ${DOCKER_IMAGE_NAME} in version ${DOCKER_IMAGE_TAG}..."

docker buildx build \
  --builder multi-arch \
  --progress auto \
  --provenance false \
  --build-arg "NGINX_VERSION=${NGINX_VERSION}" \
  --platform linux/amd64,linux/arm64 \
  --tag "taniotoshi/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}" \
  --tag "taniotoshi/${DOCKER_IMAGE_NAME}:latest" \
  --sbom true \
  --push \
  "${REPOSITORY_DIR_PATH}"

echo -e "Finished!"
