#!/bin/bash

set -e

start_path="$( cd "$(dirname "$0")" ; pwd -P )"
ros_distro=`cat ${start_path}/ros_distro`
user_name="${ros_distro}-dev"
image_tag="docker-ros-box-${ros_distro}"
image_id=`sudo docker ps -f "ancestor=${image_tag}" -f "status=running" -q`

