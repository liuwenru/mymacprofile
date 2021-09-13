#!/bin/bash
docker rm `docker ps -a | grep Exited | grep -v mysql | awk '{print $1}'`
docker rmi -f  `docker images | grep '<none>' | awk '{print $3}'`
