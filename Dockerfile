FROM centos:latest

LABEL maintainer="maciej.m.gasiorowski@gmail.com.pl"

ARG PACKER_VERSION="1.3.4"

RUN yum install -y unzip

RUN wget "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" -O /tmp/packer.zip &&\
    unzip /tmp/packer.zip -d /usr/local/bin

ENV LOAD_HOME="/load"

RUN mkdir -p ${LOAD_HOME}

COPY . ${LOAD_HOME}/

WORKDIR ${LOAD_HOME}
