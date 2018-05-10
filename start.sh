#!/bin/bash

set -e

image_id=`sudo docker ps -f "ancestor=docker-ros-box" -f "status=running" -q`
start_path="$( cd "$(dirname "$0")" ; pwd -P )"

if [ "${image_id}" != "" ]
then
	echo "docker-ros-box image already running."
	echo "try './open.sh'"
	exit 1
fi

sudo docker \
	run \
	--rm \
	-e DISPLAY=$DISPLAY \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v "${start_path}/src:/home/developer/catkin_ws/src" \
	-it docker-ros-box \
	bash

