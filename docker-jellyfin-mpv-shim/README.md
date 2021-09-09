```
docker build . -t  docker-jellyfin-mpv-shim:latest
docker run --rm -it --name docker-jellyfin-mpv-shim  -e DISPLAY=:0 -e XDG_RUNTIME_DIR=/tmp/xdgc -v xsocket:/tmp/.X11-unix:ro  --device=/dev/dri  --device=/dev/snd  docker-jellyfin-mpv-shim:latest
```