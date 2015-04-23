#!/bin/bash

# Domain name for containers
CONTAINER_DOMAIN=

# Path to the addn-hosts file
CONTAINER_HOSTS=/opt/docker/dns/docker-container-hosts

echo "# Auto-generated by $0" > $CONTAINER_HOSTS
for CID in `docker ps -q`; do
    IP=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' $CID`

    ## With container name
    NAME=`docker inspect --format '{{ .Name }}' $CID`
    NAME=${NAME#/}
    echo "$IP  $NAME.$CONTAINER_DOMAIN" >> $CONTAINER_HOSTS

    ## With hostname
    NAME=`docker inspect --format '{{ .Config.Hostname }}' $CID`
    echo "$IP  $NAME.$CONTAINER_DOMAIN" >> $CONTAINER_HOSTS
done

# Ask dnsmasq to reload addn-hosts
pkill -x -HUP dnsmasq
