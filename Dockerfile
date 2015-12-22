FROM ubuntu:14.04

MAINTAINER  Erik Osterman "e@osterman.com"

# http://www.sebastian.korotkiewicz.eu/2013/05/21/own-irc-server-on-debian-with-anope-and-mysql/
# http://www.anope.org/ilm.php?p=lm
# https://github.com/dockerimages/docker-unrealircd/blob/master/deploy-unrealirc.sh

ENV ANOPE_VERSION 2.0.2

ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

WORKDIR /usr/src

ADD config.cache /usr/src/anope-$ANOPE_VERSION-source/config.cache

RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/01buildconfig && \
    echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf.d/01buildconfig && \
    echo 'APT::Get::force-yes "true";' >> /etc/apt/apt.conf.d/01buildconfig  && \
    echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/01buildconfig && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y build-essential curl libssl-dev ca-certificates cmake && \
    curl -s --location https://github.com/anope/anope/releases/download/$ANOPE_VERSION/anope-$ANOPE_VERSION-source.tar.gz | tar xz && \
    cd anope-$ANOPE_VERSION-source && \
    ./Config -quick && \
    cd build/ && \
    make && \
    make install && \
    cp /anope/conf/example.conf  /anope/conf/services.conf && \
    apt-get -y remove build-essential cmake && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/src/*

CMD ["/anope/bin/services"]
