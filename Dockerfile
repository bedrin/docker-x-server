FROM ubuntu:21.04

# Decrease number of pacakges 
RUN apt-get update && \
    DEBIAN_FRONTEND='noninteractive'  apt-get install -y  --no-install-recommends xorg xserver-xorg-input-evdev  xserver-xorg-input-all

# TODO: keyboard should be configurable in runtime
# TODO: actually move all input related functionality to separate layer
#RUN printf "\
#Section \"ServerFlags\"\n\
#        Option \"AutoAddDevices\" \"False\"\n\
#EndSection\n\
#\n\
#Section \"ServerLayout\"\n\
#    Identifier     \"Desktop\"\n\
#    InputDevice    \"Mouse0\" \"CorePointer\"\n\
#    InputDevice    \"Keyboard0\" \"CoreKeyboard\"\n\
#EndSection\n\
#\n\
#Section \"InputDevice\"\n\
#    Identifier \"Keyboard0\"\n\
#    Option \"CoreKeyboard\"\n\
#    Option \"Device\" \"/dev/input/event4\"\n\
#    Driver \"evdev\"\n\
#EndSection\n\
#\n\
#Section \"InputDevice\"\n\
#    Identifier \"Mouse0\"\n\
#    Driver \"mouse\"\n\
#    Option \"Protocol\" \"auto\"\n\
#    Option \"Device\" \"/dev/input/mice\"\n\
#    Option \"ZAxisMapping\" \"4 5 6 7\"\n\
#EndSection\n\
#" > /etc/X11/xorg.conf.d/10-input.conf

#CMD /usr/bin/xinit /usr/bin/xterm -- :0 -nolisten tcp vt1
#CMD /usr/bin/X :0 -nolisten tcp vt1

ADD entrypoint.sh /usr/bin/entrypoint.sh

RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]