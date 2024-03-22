# Docker jokes

The Docker image is based on `nginxinc/nginx-unprivileged`.

## Example

Here is an example how to use with Docker compose.

```yml
version: '3.9'

services:
  docker-jokes:
    image: taniotoshi/docker-jokes:latest
    container_name: docker-jokes
    environment:
      # VIDEO: Rickroll-1080.pm4
      # VIDEO: EpixSaxGandalf-1080.pm4
      RANDOM_VIDEO: true # One of the videos
    ports:
      - '8080:8080'

```
