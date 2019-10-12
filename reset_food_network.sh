#!/bin/sh

docker-compose -f docker-compose-farmer.yaml -f docker-compose-supermarket.yaml -f docker-compose-cli.yaml down


docker volume prune -f
