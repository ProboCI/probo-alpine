#!/bin/bash

echo "---------------------------------------------------------------"
echo -n "Alpine - PHP 8.0 ProboCI Build: "
docker build . -q -t proboci/alpine:php8.0
if [[ ${1} = 'production' ]] || [[ ${1} = 'prod' ]]; then
  echo -n "Pushing to DockerHub: "
  docker push -q proboci/alpine:php8.0
fi

echo "---------------------------------------------------------------"
