#!/bin/bash

if [[ $# -eq 0 ]] ; then
    /usr/bin/X :0 -nolisten tcp vt1
else
    echo "$@" > /usr/bin/entrypoint-command.sh
    chmod +x /usr/bin/entrypoint-command.sh
    /usr/bin/xinit /usr/bin/entrypoint-command.sh -- :0 -nolisten tcp vt1
fi