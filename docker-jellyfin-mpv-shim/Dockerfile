FROM ubuntu:21.04

# Decrease number of pacakges 
RUN apt-get update && \
    DEBIAN_FRONTEND='noninteractive'  apt-get install -y  --no-install-recommends python3-pip libmpv1 libavformat-dev libmfx1 libmfx-tools intel-media-va-driver

RUN pip3 install --upgrade jellyfin-mpv-shim

CMD /usr/local/bin/jellyfin-mpv-shim