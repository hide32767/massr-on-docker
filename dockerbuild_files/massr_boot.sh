#!/bin/bash

start-stop-daemon --start \
  --chuid mongodb:mongodb \
  --pidfile /var/run/mongodb.pid \
  --make-pidfile \
  --exec /usr/bin/mongod -- --config /etc/mongod.conf &

/usr/share/memcached/scripts/start-memcached

su - webapp -c 'cd /srv/webapp && . ./.env; bundle exec rake assets:precompile'
su - webapp -c 'cd /srv/webapp && . ./.env; bundle exec puma --port 9393'
