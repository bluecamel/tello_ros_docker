#!/usr/bin/env bash

# Checkout submodules.
git submodule update --init --recursive --remote

# Download NVIDIA driver of the same version installed on the host.
NVIDIA_DRIVER_FILE="NVIDIA-DRIVER.run"
if test -f "${NVIDIA_DRIVER_FILE}"; then
  echo "NVIDIA driver already downloaded"
else
    NVIDIA_DRIVER_VERSION="$(glxinfo | grep "OpenGL version string" | rev | cut -d" " -f1 | rev)"
    wget http://us.download.nvidia.com/XFree86/Linux-x86_64/"${NVIDIA_DRIVER_VERSION}"/NVIDIA-Linux-x86_64-"${NVIDIA_DRIVER_VERSION}".run
    mv NVIDIA-Linux-x86_64-"${NVIDIA_DRIVER_VERSION}".run "${NVIDIA_DRIVER_FILE}"
fi

# Build the docker image.
docker build -f Dockerfile . -t tello_ros_docker:eloquent
