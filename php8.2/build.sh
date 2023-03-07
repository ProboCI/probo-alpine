#!/bin/bash

echo "---------------------------------------------------------------"
printf "Alpine - PHP 8.2 ProboCI Build: "
docker build . -q -t proboci/alpine:php8.2 ${2}
if [[ ${1} = 'production' ]] || [[ ${1} = 'prod' ]]; then
  printf "Pushing to DockerHub: "
  docker push -q proboci/alpine:php8.2
fi

echo "---------------------------------------------------------------"
