#!/usr/bin/env bash

# Required libs: docker

# Build the Docker image

# Error handling
set -Eeuo pipefail

SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

REPOSITORY_DIR_PATH="$(cd -- "${SCRIPT_DIR}/.." || return > /dev/null 2>&1 && pwd -P)"

# Variables
NGINX_VERSION="${NGINX_VERSION:-"1.25.4-alpine"}"

docker buildx build \
  --builder multi-arch \
  --progress auto \
  --provenance false \
  --build-arg "NGINX_VERSION=${NGINX_VERSION}" \
  --platform linux/amd64,linux/arm64 \
  --tag taniotoshi/docker-jokes:latest \
  --sbom true \
  --push \
  "${REPOSITORY_DIR_PATH}"
