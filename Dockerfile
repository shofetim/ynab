FROM ubuntu:15.04

MAINTAINER Jordan Schatz "jordan@noionlabs.com"

# Let apt know that we will be running non-interactively.
ENV DEBIAN_FRONTEND noninteractive

# Setup i386 architecture
RUN dpkg --add-architecture i386; \
    echo 'deb http://ppa.launchpad.net/ubuntu-wine/ppa/ubuntu vivid main' \
          >>  /etc/apt/sources.list; \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5A9A06AEF9CB8DB0

# Get the latest WINE
RUN apt-get update; apt-get install -y wine1.7 winetricks wine-mono4.5.6 wine-gecko2.34

# Set the locale and timezone.
RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || :
RUN echo "America/Los_Angeles" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

# Create a user inside the container, what has the same UID as your
# user on the host system, to permit X11 socket sharing / GUI Your ID
# is probably 1000, but you can find out by typing `id` at a terminal.
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/docker && \
    echo "docker:x:${uid}:${gid}:Docker,,,:/home/docker:/bin/bash" >> /etc/passwd && \
    echo "docker:x:${uid}:" >> /etc/group && \
    echo "docker ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/docker && \
    chmod 0440 /etc/sudoers.d/docker && \
    chown ${uid}:${gid} -R /home/docker

ENV HOME /home/docker
WORKDIR /home/docker

# Add the ynab installer to the image.
ADD ["http://www.youneedabudget.com/CDNOrigin/download/ynab4/liveCaptive/Win/YNAB%204_4.3.729_Setup.exe", "ynab_setup.exe"]

# When it is added via the dockerfile it is owned read+write only by root
RUN chown docker:docker ynab_setup.exe

USER docker
