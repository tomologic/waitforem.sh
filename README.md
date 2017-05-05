# Wait for (th)em shell script
A small script which waits until zero or more declared services are available,
before calling a chained command.

The purpose for which it was devised was to delay starting of Docker containers
until all the container's dependent services, typically other containers, have
started.

A service is here defined as a network based service, and the definition of a
service being started is that it is listening on a TCP service port. This tends
to be the situation in most of the Docker image ecosystem.

# Usage

    $ DEPENDENT_SERVICES="mq:5672 db:5432" my-program-needing-deps [program args ..]

This will run (exec into) `my-program-needing-deps` with any supplied program
arguments _after_ port 5672 at host `mq` and port `5432` at host `db` are
opened, or until the wait process times out, which by default is after 60
seconds.

To adjust the per-service-timeout, the environment variable
`DEPENDENCY_TIMEOUT` can be assigned a different duration (in seconds). If
timeout happens, a non-zero exit-code is returned by the script, and the
chained program is never called.

# Prerequisite
Bash, since the script relies on bash syntax, and a mechanism bash offers to
check for open sockets on local and remote hosts.
