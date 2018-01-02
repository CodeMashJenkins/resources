#!/bin/sh

chown :docker /var/run/docker.sock
chmod 770 /var/run/docker.sock

if ! groups jenkins | grep -q docker; then
  usermod -aG docker jenkins
fi

# drop access to jenkins user and run jenkins entrypoint
exec gosu jenkins /sbin/tini -- /usr/local/bin/jenkins.sh "$@"
