FROM osrf/ros:eloquent-desktop

# apt update/upgrade and install dependencies.
RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y
RUN apt-get install -q -y \
    libasio-dev \
    mesa-utils \
    module-init-tools \
    ros-eloquent-camera-calibration-parsers \
    ros-eloquent-cv-bridge \
    libgazebo9 \
    libgazebo9-dev \
    ros-eloquent-gazebo-ros-pkgs

# Install NVIDIA driver.
ADD NVIDIA-DRIVER.run /tmp/NVIDIA-DRIVER.run
RUN sh /tmp/NVIDIA-DRIVER.run -a --ui=none --no-kernel-module
RUN rm /tmp/NVIDIA-DRIVER.run

# Copy rviz workspace and build.
ENV RVIZ_WS_DIR /root/ros/rviz_ws
ADD rviz_ws ${RVIZ_WS_DIR}
WORKDIR  ${RVIZ_WS_DIR}
RUN /bin/bash -c "source /opt/ros/eloquent/setup.bash && colcon build --merge-install"

# Install transformations.
RUN pip3 install transformations==v2018.9.5

# Copy tello_ros workspace and build.
ENV TELLO_ROS_WS_DIR /root/ros/tello_ros_ws
ADD tello_ros_ws ${TELLO_ROS_WS_DIR}
WORKDIR ${TELLO_ROS_WS_DIR}
RUN /bin/bash -c "source /opt/ros/eloquent/setup.bash && colcon build"

# Copy env and scripts
ADD env ./env
ADD scripts/docker ./scripts

# Set entrypoint.
ENTRYPOINT ["scripts/launch.sh"]
CMD []
