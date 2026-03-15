FROM ubuntu:24.04@sha256:d1e2e92c075e5ca139d51a140fff46f84315c0fdce203eab2807c7e495eff4f9

ARG USER_UID=1000
ARG USER_GID=1000

RUN apt-get update \
    && apt-get install -y sudo \
    && groupmod --gid $USER_GID ubuntu \
    && usermod --uid $USER_UID --gid $USER_GID ubuntu \
    && echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && echo "Defaults:ubuntu !authenticate" >> /etc/sudoers \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV TERM=xterm-256color

USER ubuntu
WORKDIR /home/ubuntu/.dotfiles
