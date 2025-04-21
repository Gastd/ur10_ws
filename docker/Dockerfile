ARG FROM_IMAGE=osrf/ros:humble-desktop-full
ARG WORKSPACE=/home/gabriel/ur10_ws
ARG REPOS_FILE=./repositories


# multi-stage for caching
FROM $FROM_IMAGE AS cacher

ENV UID=1000
ENV GID=1000
ARG USER=gabriel

ARG WORKSPACE
ARG REPOS_FILE
# RUN mkdir -p "$WORKSPACE"/src
WORKDIR $WORKSPACE
COPY $REPOS_FILE repos
RUN --mount=type=ssh \
    mkdir -pm 700 ~/.ssh && \
    ssh-keyscan github.com >>~/.ssh/known_hosts
    # ssh-keyscan gitlab-ssh.irstea.fr >>~/.ssh/known_hosts && \
RUN vcs import --recursive -w6 < repos

# copy manifests for caching
# WORKDIR /opt
# RUN mkdir -p /tmp/opt && \
#     find . -name "package.xml"   | xargs cp --parents -t /tmp/opt && \
#     find . -name "COLCON_IGNORE" | xargs cp --parents -t /tmp/opt 2>/dev/null || true


# multi-stage for installing dependencies
FROM $FROM_IMAGE AS installer

ENV DEBIAN_FRONTEND=noninteractive
RUN --mount=type=cache,target=/var/lib/apt/lists \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        # you can add some ubuntu packages here \
        ros-humble-desktop-full \
        ros-humble-simulation \
        ros-humble-ros-gz \
        # ros-humble-gz-ros2-control \
        # ros-humble-gz-plugins \
        ros-humble-ros2-control \
        ros-humble-ros2-controllers \
        ros-humble-control-msgs \
        ros-humble-control-toolbox \
        ros-humble-realtime-tools \
        ros-humble-moveit-msgs \
        ros-humble-moveit-resources \
        ros-humble-controller-manager-msgs \
        ros-humble-controller-manager \
        ros-humble-kinematics-interface \
        ros-humble-ur-client-library \
        ros-humble-ur-msgs \
        ros-humble-ur \
        ros-humble-ur \
        ros-humble-moveit \
        ros-humble-rqt-robot-steering \
        ros-humble-gazebo-ros-pkgs \
        ros-humble-gazebo-ros2-control \
        ros-humble-gazebo-ros2-control-demos \
        ros-humble-pcl-ros \
        ros-humble-plotjuggler-ros \
        python3-pip \
        python3-colcon-mixin \
        python3-colcon-common-extensions \
        nlohmann-json3-dev \
        libunittest++-dev \
        libgsl-dev && \
    pip3 install --no-cache-dir \
        # you can add some pip packages here \
        numpy \
        matplotlib \
        geojson \
        pyserial \
        transforms3d \
        pyroboplan \
        pymap3d && \
    rm -rf /var/lib/apt/lists/*
RUN pip install setuptools==58.2.0
# bootstrap rosdep
# RUN rosdep init && \
#     rosdep update --rosdistro humble


ARG WORKSPACE
WORKDIR $WORKSPACE

# install package dependencies
COPY --from=cacher $WORKSPACE/src ./src
RUN --mount=type=cache,target=/var/lib/apt/lists \
    apt-get update && \
    # apt-get upgrade && \
    # rosdep install -iyr --from-paths src && \
    rm -rf /var/lib/apt/lists/*
# RUN vcs import --recursive -w6 < src/ur_simulation_gz/ur_simulation_gz.humble.repos

# fix a bug when rendering shadows in gazebo
RUN sed -i '7i \ \ depth += 0.001;  // added to fix a bug' \
   /usr/share/gazebo-11/media/materials/programs/shadow_caster_fp.glsl

# multi-stage for developing
FROM installer AS dever

ARG WORKSPACE
WORKDIR $WORKSPACE
ENV SHELL=/bin/bash
ENV UID=1000
ENV GID=1000
ARG USER=gabriel
# Remove the cloned projects to use a volume instead
# RUN rm -rf "$WORKSPACE"

RUN echo "UID=$UID, GID=$GID, USER=$USER"
# Create a user with the same UID and GID as the host user
# This is needed to access the host's X server
# and to avoid permission issues when mounting volumes
RUN groupadd -g ${GID-} $USER && \
    useradd -u ${UID-} -g ${GID-} -s /bin/bash -d /home/$USER/ -m $USER && \
    echo "Created new user $USER with UID=$UID and GID=$GID"

# Add sudo support for the non-root user
RUN apt-get update && apt-get install -y sudo \
    && echo $USER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER\
    && chmod 0440 /etc/sudoers.d/$USER \
    && rm -rf /var/lib/apt/lists/*

COPY --chmod=755 ros_entrypoint.sh ros_setup.sh /

RUN echo 'source <(register-python-argcomplete3 ros2)' >>/etc/bash.bashrc
RUN echo "source /home/$USER/.bashrc" >> /etc/bash.bashrc
RUN chown -R $USER:$USER /home/$USER

USER $USER
ENV HOME=/home/$USER
WORKDIR $HOME
RUN rosdep update
# COPY --chown=${UID}:${GID} /home/gabriel/.bashrc /home/$USER/.bashrc
RUN cp /etc/skel/.bashrc /home/$USER/.bashrc
USER root
WORKDIR $WORKSPACE

# Clean image
RUN sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/* 
ENTRYPOINT ["/ros_entrypoint.sh"]
