FROM consbio/mbtileserver:latest

LABEL maintainer="mei-admin@heig-vd.ch"

ENV TILE_DIR=/tilesets \
    TILE_VERSION_DIR=/var/lib/mbtiles-version \
    TILE_VERSION_TYPE=date \
    S6_OVERLAY_VERSION=v2.0.0.1

# * Install s6 overlay (https://github.com/just-containers/s6-overlay).
# * Create a directory to store the latest known version of the mbtiles files.
RUN apk --no-cache add --virtual setup-dependencies ca-certificates wget && \
    wget -O /tmp/s6-overlay-amd64.tar.gz https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz && \
    tar xzf /tmp/s6-overlay-amd64.tar.gz -C / && \
    rm /tmp/s6-overlay-amd64.tar.gz && \
    apk del setup-dependencies && \
    (umask 077 && mkdir "$TILE_VERSION_DIR")

# Copy s6 configuration & custom scripts.
COPY /fs/ /

# Make s6 the entrypoint.
ENTRYPOINT [ "/init" ]
