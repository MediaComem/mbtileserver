# mbtileserver

A server for map tiles in the [mbtiles](https://github.com/mapbox/mbtiles-spec)
format, based on
[consbio/mbtileserver](https://github.com/consbio/mbtileserver/) with an
additional cron job to automatically reload the tiles on changes.

## Usage

This repository provides a [Docker
image](https://hub.docker.com/r/mediacomem/mbtileserver) which extends the
existing [consbio/mbtileserver](https://hub.docker.com/r/consbio/mbtileserver)
image. Any settings used with that original image can also be used with this
one.

In addition to the mbtileserver, the image runs a cron job which runs every
minute and checks the tile directory (defined by the `$TILE_DIR` environment
variable) for changes to the tiles. If any change is detected, the script will
send a SIGHUP signal to the mbtileserver, causing it to reload the new tiles.

## Configuration

The mbtileserver is always launched with the `--enable-reload-signal` option,
since it must be able to receive the signal from the cron job. You may specify
additional command-line arguments with the `$MBTILESERVER_ARGS` environment
variable.

### Change detection mode

The `$TILE_VERSION_TYPE` environment variable determines how changes to the
tiles are detected:

* If it is `date` (the default), the script will check the paths of all
  `.mbtiles` files in the tiles directory, as well as their last modification
  times. Moving or changing the last modification time of any of these files
  will trigger a reload.
* If it is `digest`, the script will check the paths of all `.mbtiles` files in
  the tiles directory, as well as the SHA-256 hash of their contents. Moving or
  modifying the contents of any of these files will trigger a reload.

  This mode is more CPU-intensive but checks the actual contents of the files,
  not only their last modification time.

### Persistence

The script run by the cron job will save the latest "version" of the tiles in
the directory defined by the `$TILE_VERSION_DIR` environment variable for future
comparison. This directory is `/var/lib/mbtiles-version` by default.

You may store this directory in a Docker volume to avoid an extra check of the
tiles when the container restarts. This is recommended when using `digest` mode.
