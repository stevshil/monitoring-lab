#!/bin/bash

# This script is used to get the binaries required to build
filesdir=containers/itrs/files/ITRS

[[ ! -d $filesdir ]] && mkdir $filesdir

if ! which wget >/dev/null 2>&1
then
  sudo yum -y install wget
fi

cd $filesdir

if [[ ! -f geneos-gateway-5.8.2-linux-x64.tar.gz ]]
then
    wget https://www.dropbox.com/sh/q63dnt8e4b99n0p/AABkpm02yOWitt8Ju9pm71dQa/geneos-gateway-5.8.2-linux-x64.tar.gz?dl=0 -O geneos-gateway-5.8.2-linux-x64.tar.gz
fi

if [[ ! -f geneos-licd-5.7.1-linux-x64.tar.gz ]]
then
    wget https://www.dropbox.com/sh/q63dnt8e4b99n0p/AACYtUpShbXbuC1zLrJdb6Loa/geneos-licd-5.7.1-linux-x64.tar.gz?dl=0 -O geneos-licd-5.7.1-linux-x64.tar.gz
fi

if [[ ! -f geneos-netprobe-5.8.2-linux-x64.tar.gz ]]
then
    wget https://www.dropbox.com/sh/q63dnt8e4b99n0p/AACcQ2U4yRU2EmYpEcUISrr7a/geneos-netprobe-5.8.2-linux-x64.tar.gz?dl=0 -O geneos-netprobe-5.8.2-linux-x64.tar.gz
fi

if [[ ! -f jdk-8u131-linux-x64.rpm ]]
then
    wget https://www.dropbox.com/sh/q63dnt8e4b99n0p/AADTThET8zw1MA_KKN6ptKt0a/jdk-8u131-linux-x64.rpm?dl=0 -O jdk-8u131-linux-x64.rpm
fi

if [[ ! -f mysql-connector-c-shared-6.1.10-1.el7.x86_64.rpm ]]
then
    wget https://www.dropbox.com/sh/q63dnt8e4b99n0p/AAC8CGG9xRiOjxvEZc50Z5yla/mysql-connector-c-shared-6.1.10-1.el7.x86_64.rpm?dl=0 -O mysql-connector-c-shared-6.1.10-1.el7.x86_64.rpm
fi

if [[ ! -f mysql-connector-java-5.1.42.tar.gz ]]
then
    wget https://www.dropbox.com/sh/q63dnt8e4b99n0p/AACUh15sqiRxJQdivTBHXzy9a/mysql-connector-java-5.1.42.tar.gz?dl=0 -O mysql-connector-java-5.1.42.tar.gz
fi

cd ../../..
docker-compose build
