# Tello ROS Docker
This project creates a docker image for running [tello_ros](https://github.com/clydemcqueen/tello_ros/tree/master/tello_gazebo) by [clydemcqueen](https://github.com/clydemcqueen).  Please refer there for more details.

It includes gazebo and a [minor fork](https://github.com/bluecamel/rviz/tree/tello_ros) of [ros2/rviz](https://github.com/ros2/rviz) for simulation.

# Motivation (why Docker?)
Because docker is wonderful :)

Docker keeps all of the dependencies self-contained and portable.  This allows you to run any version of dependencies without corrupting your local environment.  It also makes it easy for newcomers to get things running with a couple of commands.

Additionally, docker allows for running automated tests (even with Gazebo!) in the cloud.

# Requirements
To use gazebo, a Linux host with an NVIDIA GPU is required.  It probably wouldn't take a lot of work to make this work for other hosts, but it's not something that I'm likely to spend time on (but definitely open to a PR).

Docker is obviously required :)

# Current State
Both tello_driver and tello_gazebo work, but I haven't tested everything yet (as of May 28, 2020).  You can't currently pass any node parameters to the launch commands, but you can edit the launch files to do this.  In the future, I'd like to make a single entrypoint that can pass arguments to the various launch files.

# Building the image
To build the image, run the build script:
```
./scripts/host/build.sh
```

This creates an image with the tag `tello_ros_docker:eloquent`.

# Running a container.
To run a container, simply use the run script:
```
./scripts/host/tello_driver/teleop_launch.sh
```

This sets the entrypoint to `scripts/docker/tello_driver/teleop_launch.sh`, which will source the environment files and run `ros2 launch tello_driver teleop_launch.py`.

# Running tello_gazebo
Run the script:
```
./scripts/host/tello_gazebo/simple_launch.sh
```

If everything works, this should open a Gazebo window on your host machine with the Tello model sitting on the ground.  You can then exec into the container and run ros2 commands to command the drone.

# Running other launch files
You can add scripts to `scripts/docker`, which you can then set as the entrypoint to the container (see `scripts/hosts/tello_driver/teleop_launch.sh` for an example).

If you change the launch file or add new ones, remember that you'll need to build the image again.  This should be pretty quick, as most of the image can be built from cached layers.

# Exec into a running container
You can get shell access to the container:
```
./scripts/host/exec.sh
```

This should put you in the shell, inside the `tello_ros_ws` workspace.  From here, you can do anything you want (such as publishing to topics or launching rviz).

# Environment files
There are a few environment files for convenience in the `env` directory.  When you've exec'd into a container, you can use these to easily get the environment you need.

# rviz fork
A [minor fork](https://github.com/bluecamel/rviz/tree/tello_ros) of [ros2/rviz](https://github.com/ros2/rviz) is included in the image.  There was an [image_transport bug](https://github.com/ros2/rviz/issues/207) that kept the rviz camera plugin from displaying the camera feed from Gazebo.

The fork only makes a couple of cmake changes so that other dependencies don't have to be changed in order to build it.

# Running rviz
Make sure you have a container running and then run the rviz script:
```
./scripts/host/rviz.sh
```

# TODO
- Add additional entrypoint scripts for the various ROS2 launch files.
- Make flexible entrypoint that accepts arguments for different launch files.
