#!/bin/sh
mkdir -p /mnt/app/volumes
rm -rf /app/docker/volumes
ln -s /mnt/app/volumes /app/docker
dockerd --storage-driver=overlay2 --data-root /mnt &
while (! docker stats --no-stream ); do
    echo "Waiting for Docker daemon..."
    sleep 1
done
cd ./docker && docker-compose up