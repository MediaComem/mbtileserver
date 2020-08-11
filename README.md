# mbtileserver

A server for map tiles in the [mbtiles](https://github.com/mapbox/mbtiles-spec)
format, based on
[consbio/mbtileserver](https://github.com/consbio/mbtileserver/) with an
additional script to automatically reload the tiles on changes.

All `.mbtiles` files in the `$TILE_DIR` directory will be checked for changes
every minute. If any change is detected, the mbtileserver will be sent a signal
to reload the tiles.
