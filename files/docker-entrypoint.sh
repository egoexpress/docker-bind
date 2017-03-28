#!/bin/bash

set -e

BIND_DATA_DIR=/data
BIND_USER=bind

mkdir -p ${BIND_DATA_DIR}

# populate default bind configuration if it does not exist
if [ ! -d ${BIND_DATA_DIR}/etc ]; then
  mv /etc/bind ${BIND_DATA_DIR}/etc
fi
rm -rf /etc/bind
ln -sf ${BIND_DATA_DIR}/etc /etc/bind
chmod -R 0775 ${BIND_DATA_DIR}
chown -R ${BIND_USER}:${BIND_USER} ${BIND_DATA_DIR}

if [ ! -d ${BIND_DATA_DIR}/lib ]; then
  mkdir -p ${BIND_DATA_DIR}/lib
  chown ${BIND_USER}:${BIND_USER} ${BIND_DATA_DIR}/lib
fi
rm -rf /var/lib/bind
ln -sf ${BIND_DATA_DIR}/lib /var/lib/bind

mkdir -m 0775 -p /var/run/named
chown root:${BIND_USER} /var/run/named

mkdir -m 0775 -p /var/cache/bind
chown root:${BIND_USER} /var/cache/bind

# allow arguments to be passed to named
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == named || ${1} == $(which named) ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

# launch named
if [[ -z ${1} ]]; then
  echo "Starting named..."
  exec $(which named) -c /bind/etc/named.conf -u ${BIND_USER} -g ${EXTRA_ARGS}
else
  exec "$@"
fi
