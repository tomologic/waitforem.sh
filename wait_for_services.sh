#!/usr/bin/env bash
# Waits for a set of HOSTNAME:PORTS to become available before executing the
# command arguments.
#
# Dependency: Bash (socket check feature is provided by bash)
#
# The services to wait for are provided as a string through the environment
# vairable DEPENDENT_SERVICES. E.g. DEPENDENT_SERVICES="mq:5672 bucket:9000"
# Max time to wait for a service to become available is controlled by the
# environement variable DEPENDENCY_TIMEOUT. The unit is in seconds.  The
# default is 60 seconds.

usage() {
    echo "$(basename $0) COMMAND"
    exit 2
}

wait_for_service() {
    host_port=$1
    host=${host_port%:*}
    port=${host_port#*:}
    echo -n "Waiting for service ${host}:${port} "
    for i in $(seq ${TIMEOUT_SECONDS}); do
        echo -n .
        (cat < /dev/null > /dev/tcp/${host}/${port}) >/dev/null 2>&1
        [ $? -eq 0 ] && { echo; return ;}
        sleep 1
    done
    echo "TIMEOUT wating for ${host}:${port} to become available"
    exit 1
}

[ $# -ge 1 ] || usage
TIMEOUT_SECONDS=${DEPENDENCY_TIMEOUT:-60}

for service in ${DEPENDENT_SERVICES}; do
    wait_for_service "$service"
done
exec "$@"

