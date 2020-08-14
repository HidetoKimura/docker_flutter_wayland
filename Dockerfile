FROM ubuntu:20.04

RUN sed -i.bak -e "s%http://archive.ubuntu.com/ubuntu/%http://ftp.iij.ad.jp/pub/linux/ubuntu/archive/%g" /etc/apt/sources.list
RUN apt-get update -y && apt-get upgrade -y 

# Basic commnads
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y sudo vim git cmake tmux xsel debootstrap \
    gcc build-essential pkg-config libpq-dev libssl-dev openssl \
    iputils-ping net-tools traceroute

RUN apt-get install -y nodejs npm

# For Flutter
RUN apt-get install -y clang ninja-build libgtk-3-dev unzip curl

# For Wayland/Weston
RUN apt-get install -y libgles2-mesa-dev libxml2-dev libinput-dev libpam0g-dev libgbm-dev libva-dev liblcms2-dev \
    libxcb-xkb-dev libcolord-dev python3-pip
RUN pip3 install meson

# Remove packages
RUN apt-get autoremove -y libreoffice* thunderbird firefox gnome-games rhythmbox gnome-mines aisleriot byobu \
    cheese gnome-mahjongg gnome-sudoku gnome-calendar
RUN apt-get autoclean && apt-get clean


ARG DOCKER_UID=9001
ARG DOCKER_GID=9001
ARG DOCKER_USER=user
ARG DOCKER_PASSWORD=user

RUN groupadd --gid ${DOCKER_GID} ${DOCKER_USER}
RUN useradd --create-home --uid ${DOCKER_UID} --gid ${DOCKER_GID} --groups sudo,video --shell /bin/bash ${DOCKER_USER} \
&& echo ${DOCKER_USER}:${DOCKER_PASSWORD} | chpasswd

# Wayland/Weston
RUN apt-get install -y autoconf libtool
RUN cd /root && \
    git clone git://anongit.freedesktop.org/wayland/wayland-protocols && \
    cd wayland-protocols/ && \
    ./autogen.sh --prefix=/usr/local && \ 
    make install

RUN cd /root && \
    git clone https://gitlab.freedesktop.org/wayland/wayland.git  && \
    cd wayland && \
    ./autogen.sh --prefix=/usr/local --disable-documentation && \
    make && \
    make install 

RUN apt-get install -y libdrm-dev libx11-xcb-dev
RUN cd /root && \
    git clone https://github.com/wayland-project/weston.git -b 7.0 && \
    cd weston && \
    meson build/ --prefix=/usr/local -Dimage-jpeg=false -Dimage-webp=false -Dlauncher-logind=false -Dbackend-rdp=false -Dxwayland=false \
    -Dsystemd=false -Dremoting=false -Dpipewire=false -Dsimple-dmabuf-drm=auto && \
    ninja -C build/ install && \
    ldconfig

RUN cd /root && \
    git clone https://github.com/GENIVI/dlt-daemon.git -b v2.18.5 && \
    cd dlt-daemon/ && \
    apt-get install -y cmake zlib1g-dev libdbus-glib-1-dev && \
    mkdir build && \
    cd build/ && \
    cmake .. && \
    make && \
    make install && \
    ldconfig

COPY ./settings/110.patch /root
RUN cd /root && \
    apt-get install -y libpixman-1-0 && \
    git clone https://github.com/GENIVI/wayland-ivi-extension.git && \
    cd wayland-ivi-extension/ && \
    git checkout 9bc63f152c48c5078bca8353c8d8f30293603257 && \
    git config --local user.email "you@example.com" && \
    git config --local user.name "Your Name" && \
    git am /root/110.patch  && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install && \
    ldconfig

RUN cd /root

# Enable wayland id-agent
COPY ./settings/weston.ini /etc/xdg/weston/weston.ini

# For Flutter
RUN mkdir -p /home/${DOCKER_USER}/.local/bin
COPY ./settings/flutter_init.sh /home/${DOCKER_USER}/.local/bin
RUN chmod +x /home/${DOCKER_USER}/.local/bin/flutter_init.sh 
RUN chown -R ${DOCKER_USER}:${DOCKER_USER} /home/${DOCKER_USER}

# For Flutter Wayland
RUN apt-get install -y libgl1-mesa-dev libegl1-mesa-dev libgles2-mesa-dev libxkbcommon-dev rapidjson-dev libpugixml-dev
RUN cd /root && \
    git clone https://github.com/NilsBrause/waylandpp.git -b 0.2.8 && \
    cd waylandpp && \
    mkdir build && \
    cd build/ && \
    cmake .. && \
    make && \
    make install && \
    ldconfig

USER ${DOCKER_USER}
WORKDIR /home/${DOCKER_USER}

# Flutter
RUN git clone https://github.com/flutter/flutter
RUN mv flutter /home/${DOCKER_USER}/.local/
ENV PATH $PATH:/home/${DOCKER_USER}/.local/flutter/bin/:/home/${DOCKER_USER}/.local/bin/

RUN flutter_init.sh

