#!/bin/sh

set -e

pgrep -c ^xflux$ \
|| curl -s ipinfo.io | jq -j ".loc" \
   | xargs -d, /bin/sh -c 'xflux -l $1 -g $2' sh
