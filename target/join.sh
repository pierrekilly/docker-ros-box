#!/bin/bash

set -e
source `dirname $0`/utils.include.sh

if [ "${image_id}" == "" ]
then
	echo "${image_tag} image not running."
	echo "try '`dirname $0`/start.sh'"
	exit 1
fi

sudo docker exec -it ${image_id} bash

