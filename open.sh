#!/bin/bash

image_id=`sudo docker ps -f "ancestor=docker-ros-box" -f "status=running" -q`

if [ "${image_id}" == "" ]
then
	echo "docker-ros-box image not running."
	echo "try './start.sh'"
	exit 1
fi

sudo docker exec -it ${image_id} bash

