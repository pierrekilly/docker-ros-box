FROM osrf/ros:lunar-desktop-full

RUN apt-get update && apt-get install -y sudo python-catkin-tools

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer/catkin_ws/src && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer
COPY bashrc /home/developer/.bashrc
COPY bashrc /root/.bashrc
COPY bash_profile /home/developer/.bash_profile
COPY bash_profile /root/.bash_profile

COPY rosbox_entrypoint.sh /rosbox_entrypoint.sh
ENTRYPOINT /rosbox_entrypoint.sh

