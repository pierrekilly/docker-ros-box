#!/bin/bash

current_dir=`pwd -P`
script_dir="$( cd "$(dirname "$0")" ; pwd -P )"
container_id=`cat "${script_dir}/docker_id"`

sudo=y

# If user is part of docker group, sudo isn't necessary
if groups $USER | grep &>/dev/null '\bdocker\b'; then
    sudo = n
fi

if [ "${container_id}" == "" ]
then
	echo "Error: No docker id found in '${script_dir}/docker_id'"
	exit 1
fi

# Check if the container is running

if [ "$sudo" = "y" ]; then

    if [ "`sudo docker ps -qf "id=${container_id}"`" == "" ]
    then
    	echo "Starting previously stopped container..."
    	sudo docker start "${container_id}"
    fi

    # Joining the container
    sudo docker exec -ti ${container_id} /rosbox_entrypoint.sh
else
    if [ "`docker ps -qf "id=${container_id}"`" == "" ]
    then
    	echo "Starting previously stopped container..."
    	docker start "${container_id}"
    fi

    docker exec -ti ${container_id} /rosbox_entrypoint.sh
fi

