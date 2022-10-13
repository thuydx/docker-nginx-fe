#!/bin/bash

# init nginx
if [ ! -d "/var/tmp/nginx/client_body" ]; then
  mkdir -p /run/nginx /var/tmp/nginx/client_body
  chown dev:dev -R /run/nginx /var/tmp/nginx/
fi


set -e
echo  "[INFO] HOSTNAME:$HOSTNAME, PUID:$PUID, PGID:$PGID, TZ:$TZ"
echo " bash version: "
bash --version | head -n 1
echo " dpkg version: "
dpkg -s dash | grep ^Version | awk '{print $2}'
echo " curl version: "
curl --version
echo " nvm version: "
bash -i -c 'nvm -v'
echo " node version: "
bash -i -c 'node --version'
echo " npm version: "
bash -i -c 'npm --version'
echo " "
git --version

exec "$@"