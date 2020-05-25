#!/usr/bin/env bash

xhost local:root

docker run -it --rm --privileged --name tello_ros \
    -e DISPLAY=${DISPLAY} \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    tello_ros_docker:eloquent \
    /bin/bash -c "./scripts/launch.sh"
