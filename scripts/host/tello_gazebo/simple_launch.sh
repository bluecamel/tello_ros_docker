#!/usr/bin/env bash

# Allow containers to access the host X server.
xhost local:root

docker run -it --rm --privileged --name tello_ros \
    -e DISPLAY=${DISPLAY} \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    --network host \
    --entrypoint "/root/ros/tello_ros_ws/scripts/tello_gazebo/simple_launch.sh" \
    tello_ros_docker:eloquent
