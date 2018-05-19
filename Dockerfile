FROM node:8.11.2-alpine

MAINTAINER inotom

ENV HOME=/home/app
ENV PATH=$HOME/.npm-global/bin:$PATH

RUN \
  apk update \
  && apk add --no-cache sudo shadow \
  && useradd --user-group --create-home --shell /bin/false app \
  && echo "app ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

COPY package.json package-lock.json .npmrc $HOME/work/
RUN \
  chown -R app:app $HOME/*

USER app
WORKDIR $HOME/work
RUN \
  mkdir $HOME/.npm-global \
  && npm config set prefix $HOME/.npm-global \
  && npm install -g npm@6.0.1 \
  && npm cache verify
