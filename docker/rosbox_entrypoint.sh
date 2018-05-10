#!/bin/bash
set -e

# setup ros environment
source /opt/ros/${ROS_DISTRO}/setup.bash

# setup development environement
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/
catkin build --no-status
source devel/setup.bash
cd ~

/bin/bash

