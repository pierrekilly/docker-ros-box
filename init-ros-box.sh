#!/bin/bash

set -e

current_dir=`pwd -P`
script_dir="$( cd "$(dirname "$0")" ; pwd -P )"

if [ "$2" == "" ]
then
	echo
	echo "Builds a docker image to run ROS and deploys a basic setup to work with it"
	echo
	echo "Usage: `basename $0` [ros_distro] [target]"
	echo "    ros_distro        The ROS distribution to work with (lunar, kinetic, etc.)"
	echo "    target            The target directory to deploy the basic setup"
	echo
	exit 1
fi

ros_distro="$1"
target="$2"
image_tag="docker-ros-box-${ros_distro}"
uid=`id -u`
gid=`id -g`
user_name="${ros_distro}-dev"

# Make sure the target exists
if [ ! -d "${target}" ]
then
	mkdir -p "${target}"
fi
target=$( cd "${target}" ; pwd -P )


echo "Prepare the target environment..."
# Copy target files
/bin/cp -Ri "${script_dir}/target/"* "${target}/"
if [ ! -d "${target}/src" ]
then
	mkdir "${target}/src"
fi

# Build the docker image
echo "Build the docker image... (This can take some time)"
cd "${script_dir}/docker"
sudo docker build \
	--quiet \
	--build-arg ros_distro="${ros_distro}" \
        --build-arg uid="${uid}" \
        --build-arg gid="${gid}" \
	-t ${image_tag} \
	.

echo "create a new container from this image..."
container_name="`echo ${target} | sed -e 's/[^a-zA-Z0-9_.-][^a-zA-Z0-9_.-]*/-/g' | sed -e 's/^[^a-zA-Z0-9]*//g'`"
cd "${target}"
sudo docker create \
        -e DISPLAY=$DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
        --device=/dev/dri/card0:/dev/dri/card0 \
        -v "${target}/src:/home/${ros_distro}-dev/catkin_ws/src" \
	--name "${container_name}" \
        -it ${image_tag}

sudo docker ps -aqf "name=${container_name}" > "${target}/docker_id"
chmod 444 "${target}/docker_id"


# That's it!
cd "${current_dir}"

echo
echo "Your dockerized ROS box is now ready in '${target}'."
echo "There you will find:"
echo "    docker_id     This file contains the ROS distribution used in your project."
echo "                  Do not touch this file."
echo "    src           Put your ROS project sources in this directory."
echo "                  It is automatically mounted in ~/catkin_ws/src inside the ROS box."
echo "    go.sh         Run this script to start the container and/or open a shell in it."
echo
echo "Have fun!"
echo


