# X Server in Docker

X Server running in Docker - can be used on a headless (no GUI) Linux installation like Ubuntu server connected to a display.
Great for building media-centers (like Kodi) plugged into your home TV or kiosk-like appliances (run Chrome with whatever content you like).

Requires `--privileged` flag when running a container.

# Building image

```
docker build . -t docker-x-server:latest
```

You can start container either in privileged mode:
```
docker run --name docker-x-server --privileged docker-x-server:latest
```

Or my granting `SYS_TTY_CONFIG` capability and mapping a few video related devices:
```
docker run --name docker-x-server --device=/dev/input --device=/dev/console --device=/dev/dri --device=/dev/fb0 --device=/dev/tty --device=/dev/tty1 --device=/dev/vga_arbiter --device=/dev/snd  --device=/dev/psaux --cap-add=SYS_TTY_CONFIG docker-x-server:latest
```

If you pass an argument, it would be executed using `xinit` which allows you to test it quickly by say running `xeyes`
```
docker run --name docker-x-server --device=/dev/input --device=/dev/console --device=/dev/dri --device=/dev/fb0 --device=/dev/tty --device=/dev/tty1 --device=/dev/vga_arbiter --device=/dev/snd  --device=/dev/psaux --cap-add=SYS_TTY_CONFIG docker-x-server:latest /usr/bin/xeyes
```

# Limitations

Since `udev` isn't available in Docker containers, you need to setup input methods like keyboard and mouse manually.
If you need keyboard, find the event number for your keyboard (like `/dev/input/event4`), uncomment the relevant section in `Dockerfile`, update the Device Option for keyboard accordingly and rebuild the image.

# Usage

Easiest way to use image, is to extend it.
For example if you want to run [jellyfin-mpv-shim](https://github.com/jellyfin/jellyfin-mpv-shim) in Docker, your Dockerfile might look like this:
```
FROM docker-x-server:latest

RUN apt-get update && apt-get install -y python3-pip libmpv1 libavformat-dev

RUN pip3 install --upgrade jellyfin-mpv-shim

RUN printf "\
OUTPUT=\`xrandr -display :0 -q | sed '/ connected/!d;s/ .*//;q'\`\n\
xrandr -display :0 --output \$OUTPUT --set \"Broadcast RGB\" \"Full\"\n\
xsetroot #000000\n\
xset s off -dpms\n\
/usr/local/bin/jellyfin-mpv-shim\n\
" > /usr/local/bin/jellyfin-mpv-shim-wrapper

RUN chmod +x /usr/local/bin/jellyfin-mpv-shim-wrapper

CMD /usr/bin/xinit /usr/local/bin/jellyfin-mpv-shim-wrapper -- :0 -nolisten tcp vt1
```

Another option is to run the actual application in separate container and share the X11 socket between them:

```
docker volume create --name xsocket
```

```
docker run --name docker-x-server --device=/dev/input --device=/dev/console --device=/dev/dri --device=/dev/fb0 --device=/dev/tty --device=/dev/tty1 --device=/dev/vga_arbiter --device=/dev/snd  --device=/dev/psaux --cap-add=SYS_TTY_CONFIG  -v xsocket:/tmp/.X11-unix  -d  docker-x-server:latest
```

```
docker run --rm -it -e DISPLAY=:0 -v xsocket:/tmp/.X11-unix:ro stefanscherer/xeyes
```