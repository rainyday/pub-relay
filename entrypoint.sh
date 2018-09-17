#!/bin/sh
(
if [ ! -f /cert/actor.pem ] && flock -n 9; then
  openssl genrsa -out /cert/actor.pem 4096
fi
) 9>/tmp/lock

exec "$@"