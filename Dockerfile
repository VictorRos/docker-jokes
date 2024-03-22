# syntax=docker/dockerfile:latest

ARG NGINX_VERSION
FROM nginxinc/nginx-unprivileged:${NGINX_VERSION}

USER root

ARG UID=101
ARG GID=101

# Copy files into image
COPY --link videos/*.mp4 /usr/share/nginx/html/
COPY --link --chmod=755 scripts/docker-entrypoint.d/*.sh /docker-entrypoint.d/

# Change permissions to index.html
RUN chown $UID:0 /usr/share/nginx/html/index.html

# Document what port is required
EXPOSE 8080

HEALTHCHECK \
	--interval=30s \
	--timeout=10s \
	--retries=3 \
	--start-period=10s \
	CMD curl -fss http://localhost:9090/healthz || exit 1

STOPSIGNAL SIGQUIT
USER $UID
CMD ["nginx", "-g", "daemon off;"]
