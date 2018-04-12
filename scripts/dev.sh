#!/bin/sh

set -e

: ${DBNAME:="${DBNAME:-appdb}"}
: ${APPPORT:="${APPPORT:-3000}"}
: ${ROOT_URL:="http://localhost:${PORT}"}
#: ${DBPORT:="$(( $APPPORT + 1 ))"}

export APPPORT
export ROOT_URL

cd /app
echo "MONGO_URL => $MONGO_URL"
echo "=> Starting meteor app on port: $APPPORT"
meteor run --port  $APPPORT --verbose && tail -f /dev/null

#just wait for login and manual commands:
#tail -f /dev/null
