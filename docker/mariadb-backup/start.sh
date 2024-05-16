#!/bin/bash
container=$1
wd=$(dirname $0)
if [ -z "$container" ]; then
	echo "ERROR: No docker container specified!"
	exit 1
fi

set -eu pipefail
echo "Using container $container"
docker exec -i $container /bin/bash < $wd/_do_backup.sh
# We dont need to copy the backups stored in /temp, since they're mounted as volume in the mariadb docker-compose file