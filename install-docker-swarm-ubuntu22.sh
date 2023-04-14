#/bin/bash
echo "{
    "live-restore": false
}" > /etc/docker/daemon.json
docker swarm init