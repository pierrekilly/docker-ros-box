#!/bin/bash

set -e
source `dirname $0`/utils.include.sh

if [ "${image_id}" != "" ]
then
	echo "${image_tag} image already running."
	echo "try '`dirname $0`/join.sh'"
	exit 1
fi

sudo docker \
	run \
	-e DISPLAY=$DISPLAY \
	-v /tmp/.X11-unix:/tmp/.X11-unix:rw \
	--device=/dev/dri/card0:/dev/dri/card0 \
	-v "${start_path}/src:/home/${user_name}/catkin_ws/src" \
	-it ${image_tag} \
	bash

