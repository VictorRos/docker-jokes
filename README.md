# Docker jokes <!-- omit in toc -->

Play a video such as Rickroll or Epic Sax Gandalf

- [Getting started](#getting-started)
- [Docker](#docker)
- [Development](#development)

## Getting started

How to use it with Docker compose to play one of the videos randomly.

```yml
services:
  docker-jokes:
    image: taniotoshi/docker-jokes:latest
    container_name: docker-jokes
    environment:
      # VIDEO: Rickroll-1080.mp4
      # VIDEO: EpixSaxGandalf-1080.mp4
      RANDOM_VIDEO: true # One of the videos
    ports:
      - '8080:8080'
```

## Docker

The Docker image is based on [`nginxinc/nginx-unprivileged`][nginxinc/nginx-unprivileged].

## Development

To start the Docker image in background.

```bash
# Image already built
docker-compose up -d

# Image not built
docker-compose up -d --build
```

To stop and remove the Docker image.

```bash
docker-compose down
```

<!-- Links -->

[nginxinc/nginx-unprivileged]: https://hub.docker.com/r/nginxinc/nginx-unprivileged
