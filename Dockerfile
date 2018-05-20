FROM node:8.11.2-alpine

MAINTAINER inotom

ENV HOME=/home/app
ENV PATH=$HOME/.npm-global/bin:$PATH
ENV PATH=./node_modules/.bin:$PATH

RUN \
  apk update \
  && apk add --no-cache sudo shadow git \
  && useradd --user-group --create-home --shell /bin/false app \
  && echo "app ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# https://github.com/facebook/flow/issues/3649
# https://github.com/sgerrand/alpine-pkg-glibc
RUN \
  apk --no-cache add ca-certificates wget \
  && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub \
  && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.27-r0/glibc-2.27-r0.apk \
  && apk add glibc-2.27-r0.apk

COPY package.json package-lock.json .npmrc $HOME/work/
RUN \
  chown -R app:app $HOME/*

USER app
WORKDIR $HOME/work
RUN \
  mkdir $HOME/.npm-global \
  && npm config set prefix $HOME/.npm-global \
  && npm install -g npm@6.0.1 \
  && npm cache verify \
  && mkdir node_modules
