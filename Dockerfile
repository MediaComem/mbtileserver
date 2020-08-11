FROM consbio/mbtileserver:latest

LABEL maintainer="mei-admin@heig-vd.ch"

ENV TILE_DIR=/tilesets \
    TILE_DIGEST_DIR=/var/lib/digest \
    S6_OVERLAY_VERSION=v2.0.0.1

# Install s6 overlay (https://github.com/just-containers/s6-overlay).
RUN apk --no-cache add --virtual setup-dependencies ca-certificates wget && \
    wget -O /tmp/s6-overlay-amd64.tar.gz https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz && \
    tar xzf /tmp/s6-overlay-amd64.tar.gz -C / && \
    rm /tmp/s6-overlay-amd64.tar.gz && \
    apk del setup-dependencies && \
    mkdir "$TILE_DIGEST_DIR" && \
    chmod 700 "$TILE_DIGEST_DIR"

# Copy s6 configuration & auto-reload script.
COPY /fs/ /

# Make s6 the entrypoint.
ENTRYPOINT [ "/init" ]
