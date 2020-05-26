# Tello ROS Docker
This project creates a docker image for running [tello_ros](https://github.com/clydemcqueen/tello_ros/tree/master/tello_gazebo) by [clydemcqueen](https://github.com/clydemcqueen).  Please refer there for more details.

It includes gazebo and a [minor fork](https://github.com/bluecamel/rviz/tree/tello_ros) of [ros2/rviz](https://github.com/ros2/rviz) for simulation.

# Motivation (why Docker?)
Because docker is wonderful :)

Docker keeps all of the dependencies self-contained and portable.  This allows you to run any version of dependencies without corrupting your local environment.  It also makes it easy for newcomers to get things running with a couple of commands.

Additionally, docker allows for running automated tests (even with Gazebo!) in the cloud.  I doubt anyone is going to production with Tello deployments, but this is good practice for doing that with "real" systems.

# Requirements
To use gazebo, a Linux host with an NVIDIA GPU is required.  It probably wouldn't take a lot of work to make this work for other hosts, but it's not something that I'm likely to spend time on (but definitely open to a PR).

Docker is obviously required :)

# Current State
This has currently only been tested with gazebo.  I don't yet have a Tello drone to test with, so I haven't yet setup any of the docker networking that will be needed.  This should be coming within the next week (written May 25, 2020).

# Building the image
To build the image, run the build script:
```
./scripts/host/build.sh
```

This creates an image with the tag `tello_ros_docker:eloquent`.

# Running a container.
To run a container, simply use the run script:
```
./scripts/host/run.sh
```

The default entrypoint is `scripts/docker/launch.sh`.  This will source the environment files and runs `ros2 launch tello_gazebo simple_launch.py`.  If everything works, a gazebo window should open with the Tello model on the ground.

# Running other launch files
You can change `scripts/docker/launch.sh` to run whatever you want.  You might also want to peek at `scripts/docker/run.sh` to see how a separate launch file could be selected from the CLI.

If you change the launch file, remember that you'll need to build the image again.  This should be pretty quick, as most of the image can be built from cached layers.

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
- Setup docker networking for working with a real Tello drone (I'll be getting one soon!).
- Add additional entrypoint scripts for the various ROS2 launch files.
