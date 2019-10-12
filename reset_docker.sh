#!/bin/bash

docker stop $(docker ps -qa)
docker rm -f $(docker ps -qa)
docker volume prune -f
