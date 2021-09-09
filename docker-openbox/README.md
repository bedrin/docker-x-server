```
docker build . -t  docker-openbox:latest
docker run --rm -it --name docker-openbox  -e DISPLAY=:0 -e XDG_RUNTIME_DIR=/tmp/xdgc -v xsocket:/tmp/.X11-unix:ro  --device=/dev/dri  --device=/dev/snd  docker-openbox:latest
```