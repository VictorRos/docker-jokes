#!/usr/bin/env bash

# Required libs: docker

# Build the Docker image

# Error handling
set -Eeuo pipefail # cspell:disable-line

SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

REPOSITORY_DIR_PATH="$(cd -- "${SCRIPT_DIR}/.." || return > /dev/null 2>&1 && pwd -P)"

# Variables
NGINX_VERSION="$(jq -r '.config.nginxVersion' package.json)"
DOCKER_IMAGE_NAME="$(jq -r '.name' package.json)"
DOCKER_IMAGE_TAG="$(jq -r '.version' package.json)"

# Constants
DOCKER_REGISTRY="taniotoshi"
DOCKER_PLATFORMS="linux/amd64,linux/arm64"

echo -e "Build Docker image...\n"

echo -e "Nginx version     : ${NGINX_VERSION}"
echo -e "Docker image name : ${DOCKER_IMAGE_NAME}"
echo -e "Docker image tag  : ${DOCKER_IMAGE_TAG}\n"

# Check if multi-arch buildx instance exists
is_buildx_instance_multi_arch_exist=$(docker buildx ls | { grep -q "multi-arch" && echo "true" || echo "false"; })

# Create multi-arch buildx instance if it does not exist
if [ "${is_buildx_instance_multi_arch_exist}" = "false" ]; then
  echo -e "Creating Docker buildx instance multi-arch..."
  docker buildx create \
    --name multi-arch \
    --platform "${DOCKER_PLATFORMS}" \
    --driver docker-container \
    --use \
    --bootstrap
else
  echo -e "Use Docker buildx instance multi-arch..."
fi

echo -e "Building and publishing ${DOCKER_IMAGE_NAME} in version ${DOCKER_IMAGE_TAG}..."

docker buildx build \
  --builder multi-arch \
  --progress auto \
  --provenance false \
  --build-arg "NGINX_VERSION=${NGINX_VERSION}" \
  --platform "${DOCKER_PLATFORMS}" \
  --tag "${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}" \
  --tag "${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:latest" \
  --sbom true \
  --push \
  "${REPOSITORY_DIR_PATH}/src"

echo -e "Finished!"
