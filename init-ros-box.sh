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

# Set ROS distribution
if [ -e "${target}/ros_distro" ]
then
	chmod 666 "${target}/ros_distro"
	/bin/rm "${target}/ros_distro"
fi
echo "${ros_distro}" > "${target}/ros_distro"
chmod 444 "${target}/ros_distro"

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

# That's it!
cd "${current_dir}"

echo
echo "Your dockerized ROS box is now ready in '${target}'."
echo "There you will find:"
echo "    ros_distro        This file contains the ROS distribution used in your project."
echo "                      Do not touch this file."
echo "    src               Put your ROS project sources in this directory."
echo "                      It is automatically mounted in ~/catkin_ws/src inside the ROS box."
echo "    utils.include.sh  A shell script to be included by the scripts below."
echo "    start.sh          Run this script to start the container and open a shell in it."
echo "                      You cannot run the same container several times."
echo "    join.sh           Run this script to open an additional shell in a running ROS box."
echo "                      You can run this script several times to open several shellson the same ROS box."
echo
echo "Have fun!"
echo


