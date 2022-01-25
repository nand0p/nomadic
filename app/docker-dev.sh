#!/bin/sh

docker network create -d bridge nomadic-dev

docker build -t nomadic-dev \
	     -f Dockerfile \
	     --build-arg "DATE=$(date)" \
	     --build-arg "REVISION=$(git rev-parse HEAD)" \
	     .

docker kill nomadic-dev 2> /dev/null || true
sleep 2

docker run --rm --name nomadic-dev -d --network=nomadic-dev -p 80:80 nomadic-dev
sleep 5
docker ps

echo "docker run --rm --name nomadic-dev -ti -p 80:80 nomadic-dev bash"
docker logs nomadic-dev -f
